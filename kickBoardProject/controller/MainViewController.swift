//
//  MainViewController.swift
//  kickBoardProject
//
//  Created by 이득령 on 7/23/24.
//

import UIKit
import KakaoMapsSDK
import SnapKit

class MainViewController: UIViewController, MapControllerDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        _observerAdded = false
        _auth = false
        _appear = false
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        _observerAdded = false
        _auth = false
        _appear = false
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapContainer = KMViewContainer()
        view.addSubview(mapContainer!)
        mapContainer?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapController = KMController(viewContainer: mapContainer!)
        mapController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine()
    }
    
    func authenticationSucceeded() {
        if _auth == false {
            _auth = true
        }
        
        if _appear && mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                self.mapController?.prepareEngine()
            }
        default:
            break
        }
    }
    
    func addViews() {
        let defaultPosition = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
        mapController?.addView(mapviewInfo)
    }
    
    func viewInit(viewName: String) {
        print("OK")
    }
    
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer!.bounds
        viewInit(viewName: viewName)
    }
    
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    func containerDidResized(_ size: CGSize) {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: .zero, size: size)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        _observerAdded = true
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        _observerAdded = false
    }
    
    @objc func willResignActive() {
        mapController?.pauseEngine()
    }
    
    @objc func didBecomeActive() {
        mapController?.activateEngine()
    }
    
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.equalTo(300)
            make.height.equalTo(35)
        }
        
        UIView.animate(withDuration: 0.4, delay: duration - 0.4, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
    
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool
    var _auth: Bool
    var _appear: Bool
}

