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
            
        setupView()
        setLocation()
        setNavigation()
    }
    @objc func btnTapped() {
        locationManager.startUpdatingLocation()
    
        print("위도\(locationManager.location?.coordinate.latitude)")
        print("경도\(locationManager.location?.coordinate.longitude)")
        
        guard let long = locationManager.location?.coordinate.longitude else { return }
        guard let lati = locationManager.location?.coordinate.latitude else { return }

        
        
//        KakaoMapViewController().createPoi(long: long, lati: lati)
        
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
        title = "지도"
                navigationController?.navigationBar.titleTextAttributes = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
                    NSAttributedString.Key.foregroundColor: UIColor.black
                ]
                let addButton = UIBarButtonItem(title: "불러오기", style: .plain, target: self, action: #selector(btnTapped))
                addButton.tintColor = UIColor.gray
                navigationItem.rightBarButtonItem = addButton
        
    }
   
    
}
extension MainViewController: CLLocationManagerDelegate {
    
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
    
    #Preview {
        let vc = MainViewController()
        
        return vc
    }
}
