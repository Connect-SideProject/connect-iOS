//
//  MapViewController.swift
//  App
//
//  Created by Kim dohyun on 2022/12/30.
//

import UIKit
import CoreLocation
import COCommonUI

import NMapsMap
import Then
import ReactorKit


public final class MapViewController: UIViewController {
    
    public typealias Reactor = MapViewReactor
    
    
    //MARK: Property
    private let mapLocationManager: CLLocationManager = CLLocationManager()
    
    private let mapView = NMFNaverMapView().then {
        $0.showLocationButton = true
        $0.mapView.mapType = .basic
        $0.showLocationButton  = true
        $0.mapView.maxZoomLevel = 20
    }
    
    
    //MARK: Property
    public  var disposeBag: DisposeBag = DisposeBag()
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(#function)
    }
    
    
    //MARK: LifeCycle
    public override func loadView() {
        self.view = mapView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    private func configure() {
        mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapLocationManager.delegate = self
        mapLocationManager.activityType = .automotiveNavigation
        mapLocationManager.requestAlwaysAuthorization()
    }
    
    
    private func applicationBecomeActive() {
        if mapLocationManager.accuracyAuthorization == .reducedAccuracy {
            CommonAlert.shared
                .setTitle("Connect IT 위치 허용")
                .setMessage(.message("위치 권한 허용 필수"))
                .show()
                .cancelHandler = { [weak self] in
                    self?.openLocationSettings()
                }
        }
    }
    
    private func openLocationSettings(){
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
    }
    
}


extension MapViewController: ReactorKit.View {
    
    
    public func bind(reactor: Reactor) {
        
        NotificationCenter.default
            .rx.notification(UIApplication.didBecomeActiveNotification)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                print("Show Location")
                vc.applicationBecomeActive()
            }).disposed(by: disposeBag)
        
    }
}


extension MapViewController: CLLocationManagerDelegate {
    
}
