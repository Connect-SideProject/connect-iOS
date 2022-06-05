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
            if section == 0  {
                return self.setCategoryLayout()
            } else {
                return self.setCountryProjectCategory()
            }
        }
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        
        collectionView.register(HomeCategoryCell.self, forCellWithReuseIdentifier: "HomeCategoryCell")
        collectionView.register(HomeCountryCategoryCell.self, forCellWithReuseIdentifier: "HomeCountryCategoryCell")
        
        collectionView.register(HomeCategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCategoryHeaderView")
        collectionView.register(HomeCountryCategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCountryCategoryHeaderView")
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
            widthDimension: .absolute(100),
            heightDimension: .absolute(100)
        )
        
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 5, bottom: 10, trailing: 5)
        
        let headerSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        
        
        let header: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)        
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        
        
        return section
    }
    
    
    fileprivate func setCountryProjectCategory() -> NSCollectionLayoutSection {


        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .absolute(300)
        )

        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        
        let headerSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        
        let header: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        

        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(300)
        )

        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}


//MARK: Delegate
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCell", for: indexPath) as? HomeCategoryCell
            return cell!
        } else {
            let countryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCountryCategoryCell", for: indexPath) as? HomeCountryCategoryCell
            
            return countryCell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCategoryHeaderView", for: indexPath) as? HomeCategoryHeaderView

            return header!
        } else {
            let countryHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCountryCategoryHeaderView", for: indexPath) as? HomeCountryCategoryHeaderView
            countryHeader?.country = "광진구"
            return countryHeader!
        }
    }
}
