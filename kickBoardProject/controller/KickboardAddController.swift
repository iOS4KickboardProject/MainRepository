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
    let kakaoMapVC = KakaoMapVC()
    
    let kickBoardAddView = KickBoardAddView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setLocation()
        setNavigation()
        locationSetting2()
        view = kickBoardAddView
        kickBoardAddView.reloadButton.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kickBoardAddView.battery = ""
        kickBoardAddView.kickBoardBattery.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func locationSetting() {
        guard let long = locationManager.location?.coordinate.longitude else { return }
        guard let lati = locationManager.location?.coordinate.latitude else { return }
        la = lati
        lo = long
        kakaoMapVC.btnTapped()
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
        title = "킥보드 추가"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let addButton = UIBarButtonItem(title: "추가하기", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "확인", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func addButtonTapped() {
        // 킥보드 추가 버튼 클릭
        guard let email = UserModel.shared.getUser().email else {
            print("유저 이메일 없음")
            return
        }
        let battery = kickBoardAddView.battery
        if battery == "" {
            print("배터리 정보 이상")
            showAlert(message: "배터리 상태를 선택해주세요!")
            return
        }
        
        let newKickboard = KickboardStruct(dictionary: ["battery": kickBoardAddView.battery, "id": kickBoardAddView.id, "latitude": String(la), "longitude": String(lo), "status": "N", "userEmail": email])
        
        if let kickboard = newKickboard {
            KickBoard.shared.addKickBoard(kickboard)
            print("데이터 추가")
        } else {
            print("데이터 추가 실패")
        }
        kickBoardAddView.resetId()
        view.setNeedsLayout()
        view.layoutIfNeeded()
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
    
    func locationSetting2() {
        guard let long = locationManager.location?.coordinate.longitude else { return }
        guard let lati = locationManager.location?.coordinate.latitude else { return }
        
        //manager.addPositions(long: long, lati: lati)
        
        print(long)
        print(lati)
        lo = long
        la = lati
    }
}
