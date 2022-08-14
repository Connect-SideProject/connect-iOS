//
//  HomeCategoryCollectionViewCell.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/04.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import ReactorKit


/// 홈 카테고리 셀
final class HomeCategoryCell: UICollectionViewCell {
    
    //MARK: Property
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 9)
        return $0
    }(UILabel())
    
    
    private let containerView: UIView = {
        $0.backgroundColor = UIColor.gray01
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true

        return $0
    }(UIView())
    
    private let imageView: UIImageView = {
        $0.contentMode = .scaleToFill
        
        return $0
    }(UIImageView())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Configure
    
    private func configure() {
        
        containerView.addSubview(imageView)
        
        _ = [titleLabel,containerView].map {
            self.containerView.addSubview($0)
        }
        
        
        
    }
    
}



extension HomeCategoryCell: ReactorKit.View {
    typealias Reactor = HomeFieldReactor
    
    
    func bind(reactor: HomeFieldReactor) {
        
    }
    
}
