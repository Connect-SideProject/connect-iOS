//
//  ProfileMyPostController.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/11.
//

import UIKit
import SnapKit
import Then
import RxDataSources
import ReactorKit


/// MY 내가 찜한, 게시 글 컨트롤러
public final class ProfileMyPostController: UIViewController {
    
    
    //MARK: Property
    public typealias Reactor = ProfileMyPostReactor
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var profilePostIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = .gray
    }
    
    private lazy var profilePostBackButton: UIButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ic_back_arrow"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.setTitleColor(UIColor.hex3A3A3A, for: .normal)
        $0.titleLabel?.font = .semiBold(size: 16)
        $0.titleLabel?.sizeToFit()
    }
    
    private lazy var profilePostBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: profilePostBackButton)
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<ProfileMyPostSection> = .init(configureCell: { dataSource, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .myProfilePostItem(cellReactor):
            guard let profilePostCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfilePostListCell", for: indexPath) as? MyProfilePostListCell else { return UICollectionViewCell() }
            profilePostCell.reactor = cellReactor
            return profilePostCell
        case let .myProfileBookMarkItem(cellReactor):
        guard let profileBookMarkCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfileBookMarkListCell", for: indexPath) as? MyProfileBookMarkListCell else { return UICollectionViewCell() }
        
        profileBookMarkCell.reactor = cellReactor
        return profileBookMarkCell
        }
    })
    
    
    private lazy var profilePostCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }).then {
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(MyProfilePostListCell.self, forCellWithReuseIdentifier: "MyProfilePostListCell")
        $0.register(MyProfileBookMarkListCell.self, forCellWithReuseIdentifier: "MyProfileBookMarkListCell")
        $0.backgroundColor = .hexF9F9F9
    }
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        debugPrint(#function)
    }
    
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        configure()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = profilePostBarButtonItem
    }
    
    
    //MARK: Configure
    private func configure() {
        _ = [profilePostCollectionView, profilePostIndicatorView].map {
            self.view.addSubview($0)
        }
        
        profilePostCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profilePostIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        
    }
    
    
    
}



extension ProfileMyPostController: ReactorKit.View {
    
    public func bind(reactor: Reactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$section)
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: self.profilePostCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.isPostType == .study}
            .debug("post Type -> ")
            .map { _ in "내가 쓴 글"}
            .bind(to: self.profilePostBackButton.rx.title())
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.isPostType == .bookMark }
            .debug("post Type -> ")
            .map { _ in "내가 찜한 글"}
            .bind(to: self.profilePostBackButton.rx.title())
            .disposed(by: disposeBag)
        
        profilePostBackButton
            .rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        self.profilePostCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
}



extension ProfileMyPostController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 40, height: 97)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
