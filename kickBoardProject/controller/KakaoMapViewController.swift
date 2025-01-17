//
//  MainViewController.swift
//  kickBoardProject
//
//  Created by 이득령 on 7/23/24
///

import UIKit
import KakaoMapsSDK
import CoreLocation

class KakaoMapViewController: UIViewController, MapControllerDelegate {
    
    var modalShow = false
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var shared = UserRepository.shared
    var _observerAdded: Bool
    var _auth: Bool
    var _appear: Bool
    let locationManager = CLLocationManager()

    let userRepository = UserRepository()
    private var kickboards = KickBoard.shared.setKickBoards()
    
    var lo = 0.0
    var la = 0.0
    
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
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ModalDismissed"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("ModalDismissed"), object: nil)
        setLocation()
        setNavigation()
        locationSetting()
        
        mapContainer = KMViewContainer()
        view.addSubview(mapContainer!)
        mapContainer?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapController = KMController(viewContainer: mapContainer!)
        mapController?.delegate = self
        
        //userRepository.fetchAllPois()
        KickboardRepository.shared.fetchKickboardInfos()
        createPoi()
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
        //Poi 패치
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.createPoi()
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
        let defaultPosition = MapPoint(longitude: lo, latitude: la)
        let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
        mapController?.addView(mapviewInfo)
    }
    
    func moveCamera(long: Double, lati: Double) {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: long, latitude: lati), zoomLevel: 18, mapView: mapView)
        mapView.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(autoElevation: true, consecutive: true, durationInMillis: 1000))
    }
    
    func viewInit(viewName: String) {
        print("OK")
    }
    
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer!.bounds
        viewInit(viewName: viewName)
        moveToCurrentLocation()
        createLabelLayer()
        createPoiStyle()
        createPoi()
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
    
    //MARK: - Button
    @objc
    func touchUpPresentModalButton(_ sender: UIButton) {
        let vc = RentModalViewcontroller()
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Button
    @objc func btnTapped() {
        guard let long = locationManager.location?.coordinate.longitude else { return }
        guard let lati = locationManager.location?.coordinate.latitude else { return }
        moveCamera(long: long, lati: lati)
        createPoi()
    }
    
    @objc func moveToCurrentLocation() {
        guard let long = locationManager.location?.coordinate.longitude else { return }
        guard let lati = locationManager.location?.coordinate.latitude else { return }
        
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: long, latitude: lati), zoomLevel: 15, mapView: mapView)
        mapView.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(autoElevation: true, consecutive: true, durationInMillis: 1000))
    }
    
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
    
    func createLabelLayer() { // 레이어생성
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let labelManager = mapView.getLabelManager()
        let layer = LabelLayerOptions(layerID: "poiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = labelManager.addLabelLayer(option: layer)
    }
    
    func createPoi() {
        kickboards = KickBoard.shared.setKickBoards()
        
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: "poiLayer") else {
            return
        }
        layer.clearAllItems()
        
        for kickboard in kickboards {
            if kickboard.status == "N" {
                let options = PoiOptions(styleID: "blue", poiID: "\(kickboard.id)")
                guard let latitude = Double(kickboard.latitude) else { return }
                guard let longitude = Double(kickboard.longitude) else { return }
                let point = MapPoint(longitude: longitude, latitude: latitude)
                if let poi = layer.addPoi(option: options, at: point) {
                    poi.clickable = true
                    poi.addPoiTappedEventHandler(target: self, handler: KakaoMapViewController.poiTappedHandler)
                    poi.show()
                }
            }
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "확인", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Poi 클릭 이벤트
    func poiTappedHandler(_ param: PoiInteractionEventParam) {
        print("click!!")
        print(param.poiItem.itemID)
        modalShow = true
        let id = param.poiItem.itemID
        // 유저의 상태가 빌린 상태라면 모달창이 뜨면 안된다
        if let status = UserModel.shared.getUser().lentalYn, status == "Y" {
            print("현재 사용중")
            showAlert(message: "현재 다른 킥보드를 사용중 입니다.")
            return
        }
        // 킥보드 id 로 현재 킥보드 리스트에서 킥보드를 찾고 킥보드의 상태와 유저의 상태를 변경 시켜야 함
        if KickBoard.shared.isValidKickboard(id: id) {
            let kickboard = KickBoard.shared.findKickboard(id: id)
            presentModalIfNeeded(kickboard: kickboard)
            //Poi 클릭시 화면 이동
            let long = Double(kickboard.longitude)!
            let lati = Double(kickboard.latitude)!
            
            moveCamera(long: long, lati: lati)
            
        }
    }
    
    func presentModalIfNeeded(kickboard: KickboardStruct) {
        if modalShow {
            let modalVC = RentModalViewcontroller()
            modalVC.kickboard = kickboard
            modalVC.modalPresentationStyle = .pageSheet
            if let sheet = modalVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 24.0
            }
            modalVC.preferredContentSize = CGSize(width: view.frame.width, height: 300)
            present(modalVC, animated: true, completion: nil)
        }
    }
    
    @objc func reloadData() {
        // 데이터 리로드 작업 수행
        print("Reloading data")
        createPoi()
    }
    
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
extension KakaoMapViewController {
    //MARK: - 워치 관련
    private func setLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    private func setNavigation() {
        //MARK: - 커스텀 NavigationBar Left Item
        let buttonContainer = UIView()
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "currentLocation"), for: .normal)
        button.addTarget(self, action: #selector(moveToCurrentLocation), for: .touchUpInside)
        
        buttonContainer.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        buttonContainer.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        
        let currentLocation = UIBarButtonItem(customView: buttonContainer)
        
        navigationItem.leftBarButtonItem = currentLocation
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let addButton = UIBarButtonItem(title: "불러오기", style: .plain, target: self, action: #selector(btnTapped))
        addButton.tintColor = UIColor.gray
        navigationItem.rightBarButtonItem = addButton
    }
    
}

extension KakaoMapViewController: CLLocationManagerDelegate {
    
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
#Preview {
    return KakaoMapViewController()
}
