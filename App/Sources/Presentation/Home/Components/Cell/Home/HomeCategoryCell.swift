//
//  HomeCategoryCollectionViewCell.swift
//  connectUITests
//
//  Created by Kim dohyun on 2022/06/04.
//  Copyright © 2022 sideproj. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit
import RxCocoa


/// 홈 카테고리 셀
final class HomeCategoryCell: UICollectionViewCell {
    
    //MARK: Property
    
    typealias Reactor = HomeMenuCellReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let menuTitleLabel: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return $0
    }(UILabel())
    
    
    private let containerView: UIView = {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true

        return $0
    }(UIView())
    
    private var menuImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        
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
        
        _ = [menuTitleLabel,menuImageView].map {
            containerView.addSubview($0)
        }
        
        self.contentView.addSubview(containerView)
        self.containerView.backgroundColor = .clear
        
        containerView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        menuTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(menuImageView)
            $0.top.equalTo(menuImageView.snp.bottom).offset(6)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(17)
        }
        
        menuImageView.snp.makeConstraints {
            $0.width.height.equalTo(37)
            $0.top.equalToSuperview()
        }
        
    }
    
    
}



extension HomeCategoryCell: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        
        reactor.state
            .map{ $0.menuType.menuTitle }
            .distinctUntilChanged()
            .delay(.milliseconds(180), scheduler: MainScheduler.instance)
            .bind(to: self.menuTitleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { state -> Task<Data, _> in
                Task {
                    let originImage = try await state.homeCellRepo.responseMenuImage(image: state.menuType)
                    return originImage
                }
            }.asObservable()
            .delay(.milliseconds(180), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] originImage in
                Task {
                    self?.menuImageView.image = try await UIImage(data: originImage.value)
                }
            }).disposed(by: disposeBag)
        
    }
    
}
