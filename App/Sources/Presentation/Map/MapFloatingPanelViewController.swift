//
//  BottomFloatingPanelViewController.swift
//  connect
//
//  Created by 이건준 on 2022/06/28.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit

import CODomain
import FloatingPanel
import SnapKit
import ReactorKit

enum FloatingType { // 어떤 데이터를 담은 플로팅파넬을 띄어줄지
    case who // Select customView
    case study // Select marker
    case searchResult // Search address
}

class MapFloatingPanelViewController: UIViewController {
    
    // MARK: -Properities
    let floatingType: FloatingType
    
    private var kakaoAddressResults: [KakaoMapAddress] = [] 
    
    private lazy var connectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: (view.frame.width - 20 - 15 - 15) / 2, height: 292 - 30)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 25, left: 15, bottom: 10, right: 15)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var emptyView = EmptyView()
    
    // MARK: -Init
    init(floatingType: FloatingType) {
        self.floatingType = floatingType
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(kakaoAddressResults: [KakaoMapAddress]) {
        self.init(floatingType: .searchResult)
        self.kakaoAddressResults = kakaoAddressResults
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setCollectionView(with: connectCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        connectCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(view.frame.height / 3)
        }
    }
    
    //MARK: -Configure
    private func configureUI() {
        view.backgroundColor = .systemBackground
        _ = [connectCollectionView, emptyView].map{ view.addSubview($0) }
    }
    
    private func setCollectionView(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: StudyCollectionViewCell.identifier)
        collectionView.register(WhoCollectionViewCell.self, forCellWithReuseIdentifier: WhoCollectionViewCell.identifier)
        collectionView.register(SearchAddressCollectionViewCell.self, forCellWithReuseIdentifier: SearchAddressCollectionViewCell.identifier)
    }
    
    public func checkEmpty(isEmpty: Bool) {
        print("isEmpty = \(isEmpty)")
        if isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
}

//MARK: - UICollectionViewDataSource
extension MapFloatingPanelViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch floatingType {
            case .searchResult:
                return kakaoAddressResults.count
            default:
                return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch floatingType {
            case .who:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WhoCollectionViewCell.identifier, for: indexPath) as? WhoCollectionViewCell ?? WhoCollectionViewCell()
                cell.configureUI(with: "")
                cell.delegate = self
                return cell
            case .study:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudyCollectionViewCell.identifier, for: indexPath) as? StudyCollectionViewCell ?? StudyCollectionViewCell()
                cell.configureUI(with: "")
                return cell
            case .searchResult:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchAddressCollectionViewCell.identifier, for: indexPath) as? SearchAddressCollectionViewCell ?? SearchAddressCollectionViewCell()
                cell.configureUI(with: kakaoAddressResults[indexPath.row])
                return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension MapFloatingPanelViewController: UICollectionViewDelegate {
    
}

extension MapFloatingPanelViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch floatingType {
        case .study, .who:
            return CGSize(width: (view.frame.width - 20 - 15 - 15) / 2, height: 292 - 30)
        case .searchResult:
            return CGSize(width: collectionView.frame.width, height: 60)
        }
    }
}

extension MapFloatingPanelViewController:  WhoCollectionViewCellDelegate {
    func didTappedProfileButton() {
        print("didTappedProfileButton")
        let vc = AnonymousProfileController(anonymousProfileModel: ["서울특별시 마포구 서교동", "금융, 엔터테인먼트, 뷰티/패션", "지망생"])
        vc.title = "프로필"
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
