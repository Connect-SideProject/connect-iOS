//
//  MapController.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import FloatingPanel
import NMapsMap
import ReactorKit
import RxCocoa
import SnapKit
import UIKit
import COExtensions
import COManager

protocol ConnectMapDataFuctionality {
    func showFloatingPanel(contentViewController: UIViewController, _ floatingPanelVC: FloatingPanelController)
    func moveCameraUpdate(mapView: NMFMapView, mapCoordinate: MapCoordinate)
    func addCustomImageMarkers(mapView: NMFMapView, imageName: String, mapCoordinates: [MapCoordinate])
    func addTextInfoWindows(title: String, marker: NMFMarker)
    func addWhoMarkers(mapView: NMFMapView, whoMarkerModels: [WhoMarkerModel])
}

/// 지도 화면 컨트롤러.
class MapController: UIViewController, View {
    
    // MARK: -Properties
    private let locationManager = CLLocationManager()
    private var currentLocation: MapCoordinate?
//    var guInfoWindows = [NMFInfoWindow]()
//    var markers = [NMFMarker]()
    typealias Reactor = MapReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: -UI
    private lazy var floatingPanelVC: FloatingPanelController = {
       let fpc = FloatingPanelController()
        let appearance = SurfaceAppearance()

        // Define shadows
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 40
        shadow.spread = 20
        appearance.shadows = [shadow]

        // Define corner radius and background color
        appearance.cornerRadius = 20
        appearance.backgroundColor = .clear
        
        // Set the new appearance
        fpc.contentMode = .fitToBounds
        fpc.surfaceView.appearance = appearance
        fpc.surfaceView.grabberHandle.isHidden = true // FloatingPanel Grabber hidden true
//        fpc.surfaceView.isUserInteractionEnabled = false // 아예 Fpc 안움직이게 함
        fpc.panGestureRecognizer.isEnabled = false // FloatingPanel Scroll enabled false
        return fpc
    }()
    
    private lazy var loadingView: LoadingView = .init()
    
    private let naverMapView: NMFNaverMapView = {
        $0.showLocationButton = true
        $0.mapView.mapType = .basic
        $0.mapView.positionMode = .direction
        $0.mapView.maxZoomLevel = 20
//        $0.mapView.minZoomLevel = 10
        return $0
    }(NMFNaverMapView())
    
    private let mapSearchBar: UISearchBar = {
        $0.placeholder = "지역을 검색해주세요"
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.returnKeyType = .default
        $0.spellCheckingType = .no
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.searchTextField.backgroundColor = .white
        return $0
    }(UISearchBar())
    
    // MARK: -Init
    init(reactor: Reactor = MapReactor()) { // Reactor테스팅을 위한 init메소드정의, 추후에 변경
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getCurrentLocation()
       
//        LocationManager.shared.setLocationManager()
//        ApiManager.shared.request(endPoint: .init(path: .userProfile)).subscribe(onNext: { (data: KakaoMapAddress) in
//
//        }).disposed(by: disposeBag)
        naverMapView.mapView.touchDelegate = self
        /*
            현재 위치를 가져오는 부분 코드추가해야함
         */

        addCustomImageMarkers(mapView: naverMapView.mapView, imageName: "송파구 스터디카페", mapCoordinates: [
            MapCoordinate(x: 37.5666102, y: 125.9783882),
            MapCoordinate(x: 35.5666102, y: 124.9783883),
            MapCoordinate(x: 34.5666102, y: 123.9783884),
            MapCoordinate(x: 33.5666103, y: 122.9783882),
            MapCoordinate(x: 32.5666104, y: 121.9783882),
            MapCoordinate(x: 39.5666106, y: 120.9783882),
            MapCoordinate(x: 38.5666105, y: 128.9783882)
        ])
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        guard let reactor = reactor else { return }
//        for guInfoWindow in guInfoWindows {
//            guard let info = guInfoWindow.userInfo["info"] as? GuCountViewModel,
//                  let guCountView = guInfoWindow.dataSource.view(with: guInfoWindow) as? GuCountView else { return }
//            if info.title == "송파구청" {
//                guCountView.configureUI(with: GuCountViewModel(title: "성남구청", count: 3))
//            }
//        }
////        reactor.action.onNext(.viewDidLoad)
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        naverMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapSearchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(70)
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    // MARK: -Bind
    func bind(reactor: Reactor) {
    /*
     reactor.action.onNext과 같은 방법으로 Reactor.Action을 보내줄 수 있는듯
     */
//        mapSearchBar.rx.text.orEmpty.filter{ $0.count != 0 }.distinctUntilChanged().map{MapReactor.Action.searchPlace($0)}
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
//        mapSearchBar.rx.text.orEmpty.debounce(.seconds(3), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .default)).distinctUntilChanged().filter{ $0.count != 0 }.map({ text in
//            return Reactor.Action.searchPlace(text)
//        })
//        .bind(to: reactor.action)
//        .disposed(by: disposeBag)
        self.rx.viewDidLoad
            .map{ MapReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.whoMarkerModels }
            .subscribe(onNext: { [weak self] whoMarkerModels in
                guard let `self` = self,
                      let whoMarkerModels = whoMarkerModels else { return }
                self.addWhoMarkers(mapView: self.naverMapView.mapView, whoMarkerModels: whoMarkerModels)
            })
            .disposed(by: disposeBag)
        
//        Observable.combineLatest(
//            reactor.state.map{ $0.placeStudyInfos },
//            reactor.state.map{ $0.selectedStudyMarkerLocation }
//        )
//        .subscribe(onNext: { [weak self] (placeStudyInfos, selectedStudyMarkerLocation) in
//            print("info = \(placeStudyInfos)")
//            print("selected = \(selectedStudyMarkerLocation)")
//            guard let `self` = self,
//                  let placeStudyInfos = placeStudyInfos,
//                  let selectedStudyMarkerLocation = selectedStudyMarkerLocation else { return }
//            self.moveCameraUpdate(mapView: self.naverMapView.mapView, mapCoordinate: selectedStudyMarkerLocation)
//            let contentViewController = MapFloatingPanelViewController(placeStudyInfos: placeStudyInfos)
//            self.floatingPanelVC.panGestureRecognizer.isEnabled = false
//            self.showFloatingPanel(contentViewController: contentViewController, self.floatingPanelVC)
//        })
//        .disposed(by: disposeBag)
        
        reactor.state.map{ !$0.isLoading }
            .observe(on: MainScheduler.instance)
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map{ $0.addressResult }.skip(1),
            reactor.state.map{ $0.isEmpty })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] kakaoAddresses, isEmpty in
                guard let `self` = self,
                      let kakaoAddresses = kakaoAddresses else { return }
                let contentViewController = MapFloatingPanelViewController(kakaoAddressResults: kakaoAddresses)
                contentViewController.checkEmpty(isEmpty: isEmpty)
                self.floatingPanelVC.panGestureRecognizer.isEnabled = true
                self.showFloatingPanel(contentViewController: contentViewController, self.floatingPanelVC)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: -Configure
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true // 네비게이션바에 의해 searchBar가 가려지는 현상 방지
        view.addSubview(naverMapView)
        view.addSubview(mapSearchBar)
        view.addSubview(loadingView)
        mapSearchBar.delegate = self
    }
    
    private func presentSettingAlert() {
        let alert = UIAlertController(title: "Connnect 알림", message: "위치권한허용필수", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            guard let `self` = self else { return }
            self.presentSettingWindow { isEnabled in
                if isEnabled {
                    print("Location Authorization success")
                } else {
                    print("Location Authorization failed")
                }
            }
        }))
        self.present(alert, animated: true)
    }
}

//MARK: -ConnectMapDataSource
extension MapController: ConnectMapDataFuctionality {
    func showFloatingPanel(contentViewController: UIViewController, _ floatingPanelVC: FloatingPanelController) {
        guard let contentViewController = contentViewController as? MapFloatingPanelViewController else { return }
        DispatchQueue.main.async {
            let layout = MapFloatingPanelLayout(floatingType: contentViewController.floatingType)
            floatingPanelVC.layout = layout
            floatingPanelVC.delegate = self
            floatingPanelVC.addPanel(toParent: self)
            floatingPanelVC.set(contentViewController: contentViewController)
            floatingPanelVC.track(scrollView: contentViewController.connectCollectionView)
            floatingPanelVC.show()
        }
    }
    
    func moveCameraUpdate(mapView: NMFMapView, mapCoordinate: MapCoordinate) { // 지도카메라 위치이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: mapCoordinate.x, lng: mapCoordinate.y))
        cameraUpdate.reason = 3
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 2
        
        mapView.moveCamera(cameraUpdate)
    }
    
    func addCustomImageMarkers(mapView: NMFMapView, imageName: String, mapCoordinates: [MapCoordinate]) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            var markers = [NMFMarker]()
            guard let `self` = self else { return }
            for mapCoordinate in mapCoordinates {
                let marker = NMFMarker()
                let position = NMGLatLng(lat: mapCoordinate.x, lng: mapCoordinate.y)
                marker.position = position
                marker.iconImage = NMFOverlayImage(image: UIImage(systemName: "person.fill")!)
//                marker.userInfo = ["info": GuCountViewModel(title: "송파구청", count: 3)]
                marker.touchHandler = { [weak self] _ in // 이 부분에 마커, 커스텀뷰에 따라 분기처리해주면 될듯
                    guard let `self` = self else { return false }
                    self.moveCameraUpdate(mapView: mapView, mapCoordinate: mapCoordinate)
                    let contentViewController = MapFloatingPanelViewController(floatingType: .who)
                    self.floatingPanelVC.panGestureRecognizer.isEnabled = false
                    self.showFloatingPanel(contentViewController: contentViewController, self.floatingPanelVC)
                    return true
                }
                
                markers.append(marker)
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                for marker in markers {
                    self.addTextInfoWindows(title: imageName, marker: marker)
                    marker.mapView = mapView
                }
            }
        }
    }
    
    func addTextInfoWindows(title: String, marker: NMFMarker) {
        let infoWindow = NMFInfoWindow()
        let dataSource = NMFInfoWindowDefaultTextSource.data()
        dataSource.title = title
        infoWindow.dataSource = dataSource
        infoWindow.open(with: marker)
    }
    
    func addWhoMarkers(mapView: NMFMapView, whoMarkerModels: [WhoMarkerModel]) { // Who전용 원형커스텀뷰
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let `self` = self else { return }
            var guInfoWindows = [NMFInfoWindow]()
            for whoMarkerModel in whoMarkerModels {
                guard let location = whoMarkerModel.location else { return }
                let guInfoWindow = NMFInfoWindow()
                let position = NMGLatLng(lat: location.x, lng: location.y)
                guInfoWindow.position = position
                guInfoWindow.dataSource = self
                guInfoWindow.userInfo = ["info": whoMarkerModel]
                guInfoWindow.touchHandler = { [weak self] whoMarker in // 이 부분에 마커, 커스텀뷰에 따라 분기처리해주면 될듯
                    guard let `self` = self,
                          let reactor = self.reactor,
                          let whoMarkerInfo = whoMarker.userInfo["info"] as? WhoMarkerModel,
                          let location = whoMarkerInfo.location else { return false }
                    
                        self.moveCameraUpdate(mapView: self.naverMapView.mapView, mapCoordinate: location)
                    let contentViewController = MapFloatingPanelViewController(floatingType: .who)
                        self.floatingPanelVC.panGestureRecognizer.isEnabled = false
                        self.showFloatingPanel(contentViewController: contentViewController, self.floatingPanelVC)
//                    Observable.just(Reactor.Action.tapWhoMarker)
//                        .bind(to: reactor.action)
//                        .disposed(by: self.disposeBag)
                    return true
                }
                guInfoWindows.append(guInfoWindow)
            }
            
            DispatchQueue.main.async {
                for guInfoWindow in guInfoWindows {
                    guInfoWindow.open(with: mapView)
                }
            }
        }
    }
}

//MARK: -Current LocationButton Feature
extension MapController: CLLocationManagerDelegate {
    private func presentSettingWindow(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            completion(false)
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            completion(true)
        }
    }
    
    private func getCurrentLocation() { // 첫 현재위치를 위한 권한 받아오기위한 함수
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation() // 이 함수를 호출함으로써 didUpdateLocations로 현재위치를 받을 수 있음
            UserDefaultsManager.currentLocation = currentLocation
        } else {
            print("위치 서비스 Off 상태")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // CLLocationManager를 이용한 현재 위도경도가져오기
            /*
                해당 위치는 네이버맵스에서 이동하는 화면좌표와 전혀 무관
                오로지 locationManager를 통한 현재위치에만 해당
                stopUpdatingLocation()을 해주지않으면 쓸데없이 계속 위치정보를 업데이트할 수 있다
             */
        let location: CLLocation = locations[locations.count - 1]
        let longtitude: CLLocationDegrees = location.coordinate.longitude
        let latitude:CLLocationDegrees = location.coordinate.latitude
        print("location = \(location), longtitude = \(longtitude), latitude = \(latitude)")
        var currentLocation = MapCoordinate(x: latitude, y: longtitude)
        self.currentLocation = currentLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { // 현재 위치를 가져올 수 있는 권한상태확인
            //location5
            switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    print("GPS 권한 설정됨")
                case .restricted, .notDetermined:
                    print("GPS 권한 설정되지 않음")
                    presentSettingAlert()
                case .denied:
                    print("GPS 권한 요청 거부됨")
                    presentSettingAlert()
                default:
                    print("GPS: Default")
            }
        }
}

//MARK: -NaverMaps Feature
extension MapController: NMFOverlayImageDataSource, NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        view.endEditing(true)
         // 만약 mapSearchBar가 반응하여 키보드가 올라왔을 경우에만 해당
            mapSearchBar.resignFirstResponder()
            removePanelFromParent(fpc: floatingPanelVC)
    }
    
    func view(with overlay: NMFOverlay) -> UIView {
        guard let studyMarkerInfo = overlay.userInfo["info"] as? WhoMarkerModel else {
            return UIView(frame: .zero)
        }
        
        let vw = GuCountView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        vw.configureUI(with: studyMarkerInfo)
        return vw
    }
}

//MARK: -FloatingPanel Setting
extension MapController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        if fpc.state == .hidden {
            removePanelFromParent(fpc: fpc)
        }
    }
    
    private func removePanelFromParent(fpc: FloatingPanelController) {
        fpc.removePanelFromParent(animated: true)
    }
}

class MapFloatingPanelLayout: FloatingPanelLayout {
    
    init(floatingType: FloatingType) { // FloatingType에 따라 다른 initialState를 갖게 함
        switch floatingType {
            case .who, .study:
                initialState = .half
            case .searchResult:
                initialState = .tip
        }
    }
    
    var position: FloatingPanelPosition {
        return .bottom
    }
    
    let initialState: FloatingPanelState
    
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
                    .full: FloatingPanelLayoutAnchor(fractionalInset: 1, edge: .bottom, referenceGuide: .safeArea),
                    .half: FloatingPanelLayoutAnchor(fractionalInset: 0.48, edge: .bottom, referenceGuide: .safeArea),
                    .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.3, edge: .bottom, referenceGuide: .safeArea), // tabbar에 가려져서 이에 맞춘 크기가 20이 적당하다생각
                    .hidden: FloatingPanelLayoutAnchor(absoluteInset: 20, edge: .bottom, referenceGuide: .safeArea)
                ]
    }
}

extension MapController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let reactor = reactor,
              let text = searchBar.text else { return }
        reactor.textObserver.onNext(text)
        searchBar.searchTextField.resignFirstResponder()
    }
    
//    accesory
}
