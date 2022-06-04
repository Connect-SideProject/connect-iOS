//
//  HomeController.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import SnapKit

/// 홈 화면 컨트롤러.
class HomeController: UIViewController {
    
    
    private lazy var collectionView: UICollectionView = {
        let compositionalLayout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { [weak self] (section,env) ->  NSCollectionLayoutSection? in
            guard let `self` = self else { return nil }
            return self.setCategoryLayout()
        }
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        
        collectionView.register(HomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCategoryCollectionViewCell")
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
      
    configure()
  }

    private func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}




extension HomeController {
    
    fileprivate func setCategoryLayout() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )
        
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 5, bottom: 10, trailing: 5)
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        
        return section
    }
}


//MARK: Delegate
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {

    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCollectionViewCell", for: indexPath) as? HomeCategoryCollectionViewCell
        return cell!
    }
}
