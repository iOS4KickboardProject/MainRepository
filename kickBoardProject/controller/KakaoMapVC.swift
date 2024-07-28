//
//  KakaoMapVC.swift
//  kickBoardProject
//
//  Created by 박승환 on 7/26/24.
//

import Foundation
import UIKit
import SnapKit
import CoreLocation
import KakaoMapsSDK

class KakaoMapVC: UIViewController, MapControllerDelegate {
    // KakaoMap
    // 변수 부분
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var shared = UserRepository.shared
    var _observerAdded: Bool
    var _auth: Bool
    var _appear: Bool
    let locationManager = CLLocationManager()
    let userRepository = UserRepository()
    var lo: Double = 0.0
    var la: Double = 0.0
    
    // 클래스 생성 삭제 부분
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
    
    // 뷰컨 생성 주기 부분
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        locationSetting()
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
    
    // 뷰를 사용하지 않는 상태로 들어갈 때 엔진의 작동을 중지
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()
    }
    
    // 뷰를 아에 메모리에서 내리는 중이라면 옵저버를 삭제하고, 엔진을 아예 새 상태로 리세시킴
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
    
    // 지도 생성 메소드
    func addViews() {
        let defaultPosition = MapPoint(longitude: lo, latitude: la)
        let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
        mapController?.addView(mapviewInfo)
    }
    
    // 맵 이동 메서드
    func moveCamera(long: Double, lati: Double) {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: long, latitude: lati), zoomLevel: 15, mapView: mapView)
        mapView.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(autoElevation: true, consecutive: true, durationInMillis: 1000))
    }
    
    // 뷰 init
    func viewInit(viewName: String) {
        print("OK")
    }
    
    // 뷰 추가 성공시 실행할 메서드
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer!.bounds
        viewInit(viewName: viewName)
        moveCamera(long: lo, lati: la)
        createLabelLayer()
        createPoiStyle()
        createPoi()
    }
    
    // 뷰 추가 실패시 실행할 메서드
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    //  컨테이너 사이즈 재조정
    func containerDidResized(_ size: CGSize) {
        let mapView = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: .zero, size: size)
    }
    
    // 옵저버 생성 메서드
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil) // 앱이 백그라운드 같이 비활성화 될 때 엔진이 멈추게 하는 옵저버를 생성
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil) // 앱이 활성 상태가 되었을 때 엔진을 다시 작동상태로 수정
        _observerAdded = true
    }
    
    // 옵저버 삭제 메서드
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        _observerAdded = false
    }
    
    // 맵 컨트롤러 어딘가에서 사용할 메서드
    @objc func willResignActive() {
        // 엔진을 잠시 중단시키는 메서드
        mapController?.pauseEngine()
    }
    
    // 애도 마찬가지
    @objc func didBecomeActive() {
        // 엔진을 다시 실행시키는 메서드
        mapController?.activateEngine()
    }
    
    // 오류 발생 시 보여줄 Toast 생성 메서드
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
    
    
    //위치 가져오는 메서드
    @objc func btnTapped() {
        guard let long = locationManager.location?.coordinate.longitude else { return }
        guard let lati = locationManager.location?.coordinate.latitude else { return }
        moveCamera(long: long, lati: lati)
        createPoi()
    }
    
    // poi 스타일 정의
    func createPoiStyle() { // 보이는 스타일 정의
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        let image = UIImage(named: "kickboard.png")
        let icon = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: icon, level: 0)
        let poiStyle = PoiStyle(styleID: "blue", styles: [perLevelStyle])
        labelManager.addPoiStyle(poiStyle)
    }
    
    // poi 라벨 레이어 생성
    func createLabelLayer() { // 레이어생성
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let labelManager = mapView.getLabelManager()
        let layer = LabelLayerOptions(layerID: "poiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = labelManager.addLabelLayer(option: layer)
    }
    
    func createPoi() {
        guard let long = locationManager.location?.coordinate.longitude else { return }
        guard let lati = locationManager.location?.coordinate.latitude else { return }
        
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: "poiLayer") else {
            return
        }
        layer.clearAllItems()
        let mapPoint = MapPoint(longitude: long, latitude: lati)
        let option = PoiOptions(styleID: "blue", poiID: "createKickboard")
        if let poi = layer.addPoi(option: option, at: mapPoint) {
            poi.clickable = true
            poi.show()
        }
    }
    
    // poi 클릭시 나올 메서드
    func poiTappedHandler(_ param: PoiInteractionEventParam) {
        print("click!!")
        print(param.poiItem.itemID)
    }
    
    // mapview 새로고침
    func reloadMapView() {
        guard let mapContainer = mapContainer else { return }
        
        // 현재 Map View 제거
        mapContainer.removeFromSuperview()
        
        // 새로운 Map Container 및 Map View 생성
        let newMapContainer = KMViewContainer()
        view.addSubview(newMapContainer)
        newMapContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapController = KMController(viewContainer: newMapContainer)
        mapController?.delegate = self
        mapController?.prepareEngine()
        
        // 다시 POI를 추가합니다
        createLabelLayer()
        createPoiStyle()
        createPoi()
    }
    
}

extension KakaoMapVC: CLLocationManagerDelegate {
    // CoreLocation
    private func setLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startLoactionUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("권한 설정됨")
            case .notDetermined:
                print("권한 설정되지 않음")
            case .restricted:
                print("권한 요청 거부됨")
            default:
                print("GPS default")
                
            }
        }
        
    }
    
    func locationSetting() {
        guard let long = locationManager.location?.coordinate.longitude else { return }
        guard let lati = locationManager.location?.coordinate.latitude else { return }
        lo = long
        la = lati
    }
}
