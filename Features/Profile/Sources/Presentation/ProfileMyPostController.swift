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
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<ProfileMyPostSection> = .init(configureCell: { dataSource, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .myProfilePostItem(cellReactor):
            guard let profilePostCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfilePostListCell", for: indexPath) as? MyProfilePostListCell else { return UICollectionViewCell() }
            profilePostCell.reactor = cellReactor
            return profilePostCell
        }
    })
    
    
    private lazy var profilePostCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }).then {
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(MyProfilePostListCell.self, forCellWithReuseIdentifier: "MyProfilePostListCell")
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
    
    
    //MARK: Configure
    private func configure() {
        _ = [profilePostCollectionView, profilePostIndicatorView].map {
            self.view.addSubview($0)
        }
        
        profilePostCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        
        reactor.state
            .map { $0.section}
            .observe(on: MainScheduler.instance)
            .bind(to: self.profilePostCollectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        self.profilePostCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
}



extension ProfileMyPostController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 40, height: 97)
    }
    
}
