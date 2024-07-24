//
//  MainViewController.swift
//  kickBoardProject
//
//  Created by 이득령 on 7/23/24.
//

import UIKit
import SnapKit
import KakaoMapsSDK
import CoreLocation

class MainViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var la: Double!
    var lo: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogInViewController()
        //setupView()
        //setLocation()
    }
    func setupLogInViewController(){
        let loginView = LoginViewController()
        addChild(loginView)
        self.view.addSubview(loginView.view)
        loginView.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loginView.didMove(toParent: self)
    }
}

extension MainViewController {
    //MARK: - View 설정
    private func setupView() {
        let apiSampleVC = KakaoMapViewController()
        addChild(apiSampleVC)
        view.addSubview(apiSampleVC.view)
        apiSampleVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        apiSampleVC.didMove(toParent: self)
    }
    //MARK: - 워치 관련
    private func setLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    private func setNavigation() {
        let appearance = UINavigationBarAppearance()
    }
    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
}
extension MainViewController: CLLocationManagerDelegate {
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
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

#Preview {
    let vc = MainViewController()
    
    return vc
}
