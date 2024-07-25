//
//  AddKickboardController.swift
//  kickBoardProject
//
//  Created by 박승환 on 7/23/24.
//

import UIKit
import SnapKit
import KakaoMapsSDK
import CoreLocation

class KickboardAddController: UIViewController {
    
    let locationManager = CLLocationManager()

    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var la: Double!
    var lo: Double!
    let manager = MapManager.manager
    let kakaoMapVC = KakaoMapViewController()
    
    let kickBoardAddView = KickBoardAddView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLocation()
        setNavigation()
        view = kickBoardAddView
        kickBoardAddView.reloadButton.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func locationSetting() {
        guard let long = locationManager.location?.coordinate.longitude else { return }
        guard let lati = locationManager.location?.coordinate.latitude else { return }
        
        //manager.addPositions(long: long, lati: lati)
        
        print(long)
        print(lati)
        
        kakaoMapVC.createPoi()
        
        kakaoMapVC.moveCamera(long: long, lati: lati)
    }
    
    @objc func btnTapped() {
        locationSetting()
    }
}

extension KickboardAddController {
    //MARK: - View 설정
    private func setupView() {
        
        addChild(kakaoMapVC)
        kickBoardAddView.mapView.addSubview(kakaoMapVC.view)
//        view.addSubview(apiSampleVC.view)
        kakaoMapVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        kakaoMapVC.didMove(toParent: self)
    }
    //MARK: - 워치 관련
    private func setLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setNavigation() {
        title = "지도"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
//                let addButton = UIBarButtonItem(title: "불러오기", style: .plain, target: self, action: #selector(btnTapped))
//                addButton.tintColor = UIColor.gray
//                navigationItem.rightBarButtonItem = addButton
        
    }
}

extension KickboardAddController: CLLocationManagerDelegate {
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
}
