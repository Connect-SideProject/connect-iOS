//
//  SearchKeywordListCell.swift
//  App
//
//  Created by Kim dohyun on 2022/11/22.
//

import UIKit
import SnapKit
import Then

import RxSwift
import RxCocoa
import ReactorKit


/// 검색 키워드 셀

final class SearchKeywordListCell: UICollectionViewCell {
    
    
    typealias Reactor = SearchKeywordCellReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let keywordContainerView: UIView = UIView().then {
        $0.backgroundColor = .hexF9F9F9
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private let keywordTitleLabel: UILabel = UILabel().then {
        $0.textColor = .hex8E8E8E
        $0.font = .regular(size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    
    private let keywordImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "ic_close")
        $0.contentMode = .scaleAspectFit
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    
    private func configure() {
        
        self.contentView.addSubview(keywordContainerView)
        _ = [keywordTitleLabel, keywordImageView].map {
            keywordContainerView.addSubview($0)
        }
        
        keywordContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        keywordTitleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.left.equalToSuperview().offset(11)
            $0.height.equalTo(17)
            $0.centerY.equalToSuperview()
        }
        
        keywordImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.left.equalTo(keywordTitleLabel.snp.right).offset(6)
            $0.right.equalToSuperview().offset(-11)
            $0.centerY.equalTo(keywordTitleLabel)
        }
        
    }
    
    
}



extension SearchKeywordListCell: ReactorKit.View {
    
    func bind(reactor: Reactor) {
        
        reactor.state
            .map { $0.keywordItems }
            .bind(to: keywordTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        keywordImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                var removeArray =  UserDefaults.standard.stringArray(forKey: .recentlyKeywords)
                removeArray.remove(at: self.reactor?.currentState.indexPath ?? 1)
                UserDefaults.standard.set(removeArray, forKey: .recentlyKeywords)
                SearchViewTransform.event.onNext(.refreshKeywordSection)
            }).disposed(by: disposeBag)
        
    }
}
