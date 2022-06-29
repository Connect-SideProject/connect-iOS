//
//  MapController.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import FloatingPanel
import SnapKit
import UIKit

/// 지도 화면 컨트롤러.
class MapController: UIViewController {
    
    private lazy var floatingPanelVC = FloatingPanelController()
    
//    private let mapSearchView: MapSearchView = {
//       let mapSearchView = MapSearchView()
//        return mapSearchView
//    }()
    
    private let mapSearchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "지역을 검색해주세요"
        return searchBar
    }()
    
    private let mapView: MTMapView = {
       let mapView = MTMapView()
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let contentViewController = MapFloatingPanelViewController()
        setFloatingPanel(contentViewController: contentViewController, floatingPanelVC)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        mapSearchView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(50)
//        }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        mapSearchBar.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.top.left.equalToSuperview().offset(10)
//            make.right.equalToSuperview().offset(-10)
//            make.height.equalTo(50)
//        }
    }
    
    //MARK: -Configure
    private func configureUI() {
        view.addSubview(mapView)
//        view.addSubview(mapSearchBar)
    }
    
    private func setFloatingPanel(contentViewController: UIViewController, _ floatingPanelVC: FloatingPanelController) {
        let layout = MapFloatingPanelLayout()
        floatingPanelVC.layout = layout
        floatingPanelVC.delegate = self
        floatingPanelVC.addPanel(toParent: self)
        floatingPanelVC.set(contentViewController: contentViewController)
        floatingPanelVC.show()
    }

}

//MARK: -Custom View
//extension MapController {
//    class MapSearchView: UIView {
//
//        private let searchBar: UISearchBar = {
//           let searchBar = UISearchBar()
//            searchBar.placeholder = "프로젝트와 스터디를 검색해보세요."
//            return searchBar
//        }()
//
//        private let filterButton: UIButton = {
//           let button = UIButton()
//            button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
//            return button
//        }()
//
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            configureUI()
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            searchBar.snp.makeConstraints { make in
//                make.left.equalToSuperview().offset(10)
//                make.right.equalTo(filterButton.snp.left).offset(-10)
//                make.height.equalToSuperview()
//                make.centerY.equalToSuperview()
//            }
//
//            filterButton.snp.makeConstraints { make in
//                make.centerY.equalToSuperview()
//                make.right.equalToSuperview().offset(-10)
//            }
//        }
//
//        private func configureUI() {
//            self.backgroundColor = .systemBackground
//            self.addSubview(searchBar)
//            self.addSubview(filterButton)
//        }
//    }
//}

//MARK: -FloatingPanel Setting
extension MapController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        if fpc.state == .tip {
            floatingPanelVC.removePanelFromParent(animated: true)
        }
    }
}

class MapFloatingPanelLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition {
        return .bottom
    }
    
    var initialState: FloatingPanelState {
        return .half
    }
    
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
                    .half: FloatingPanelLayoutAnchor(absoluteInset: 292, edge: .bottom, referenceGuide: .safeArea),
                    .tip: FloatingPanelLayoutAnchor(absoluteInset: 20.0, edge: .bottom, referenceGuide: .safeArea) // tabbar에 가려져서 이에 맞춘 크기가 20이 적당하다생각
                ]
    }
    
    
}

