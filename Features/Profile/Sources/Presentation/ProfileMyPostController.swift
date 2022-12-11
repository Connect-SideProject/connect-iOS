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


/// MY 내가 찜한, 게시 글 컨트롤러
final class ProfileMyPostController: UIViewController {
    
    
    //MARK: Property
    private lazy var profilePostIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = .gray
    }
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<ProfileMyPostSection> = .init(configureCell: { dataSource, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case .myProfilePostItem: break
            guard let profilePostCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfilePostListCell", for: indexPath) as? MyProfilePostListCell else { return UICollectionViewCell() }
            return profilePostCell
        }
    })
    
    
    private let profilePostCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }).then {
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(MyProfilePostListCell.self, forCellWithReuseIdentifier: "MyProfilePostListCell")
    }
    
    private let profilePostView: UICollectionView = UICollectionView().then {
        $0.backgroundColor = .hexF9F9F9
        $0.isScrollEnabled = false
    }
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
