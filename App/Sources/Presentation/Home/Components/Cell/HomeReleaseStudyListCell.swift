//
//  HomeReleaseStudyListCell.swift
//  connect
//
//  Created by Kim dohyun on 2022/10/07.
//

import UIKit
import SnapKit
import Then
import ReactorKit


/// 홈 Hot 게시글 셀
final class HomeReleaseStudyListCell: UICollectionViewCell {
    
    //MARK: Property
    
    typealias Reactor = HomeReleaseCellReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let releaseContainerView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
        $0.layer.borderColor = UIColor.hexEDEDED.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let releaseStateContainerView: UIView = UIView().then {
        $0.backgroundColor = .hex06C755
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 2
    }
    
    private let releaseStateLabel: UILabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    private let releaseBookMarkCountLabel: UILabel = UILabel().then {
        $0.textColor = .hex8E8E8E
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let releaseBookMarkContainerView: UIView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let releaseBookMarkImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_bookmark")
    }
    
    private lazy var releaseBookMarkStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.addArrangedSubview(releaseBookMarkContainerView)
        $0.addArrangedSubview(releaseBookMarkCountLabel)
    }
    
    private let releaseTitleLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let releaseSubTitleLabel: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 4
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let releaseMemberStateImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_member")
    }
    
    private let releaseMemberStateLabel: UILabel = UILabel().then {
        $0.textColor = .hex8E8E8E
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    private let releaseMangerConfirmView: UIView = UIView().then {
        $0.backgroundColor = .hex3A3A3A
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    private let releaseMangerConfirmTitleLabel: UILabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .center
    }
    
    
    
    //MARK: Initizations
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
    
    
    
    //MARK: Configure
    private func configure() {
        self.contentView.addSubview(releaseContainerView)
        
        releaseStateContainerView.addSubview(releaseStateLabel)
        releaseBookMarkContainerView.addSubview(releaseBookMarkImageView)
        releaseMangerConfirmView.addSubview(releaseMangerConfirmTitleLabel)
        
        _ = [releaseTitleLabel,releaseSubTitleLabel,releaseBookMarkStackView, releaseStateContainerView, releaseMemberStateLabel, releaseMemberStateImageView,releaseMangerConfirmView ].map {
            self.releaseContainerView.addSubview($0)
        }
        
        
        releaseContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        releaseStateContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(18)
        }
        
        releaseStateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        releaseBookMarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        releaseBookMarkStackView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(releaseStateContainerView)
            $0.centerY.equalToSuperview()
        }
        
        releaseTitleLabel.snp.makeConstraints {
            $0.top.equalTo(releaseStateContainerView.snp.bottom).offset(10)
            $0.left.equalTo(releaseStateContainerView)
            $0.height.equalTo(19)
        }
        
        releaseSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(releaseTitleLabel.snp.bottom).offset(6)
            $0.left.equalTo(releaseTitleLabel)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        releaseMemberStateImageView.snp.makeConstraints {
            $0.top.equalTo(releaseSubTitleLabel.snp.bottom).offset(10)
            $0.left.equalTo(releaseSubTitleLabel)
            $0.width.height.equalTo(16)
        }
        
        releaseMemberStateLabel.snp.makeConstraints {
            $0.left.equalTo(releaseMemberStateImageView.snp.right).offset(5)
            $0.height.equalTo(14)
            $0.centerY.equalToSuperview()
        }
        
        releaseMangerConfirmView.snp.makeConstraints {
            $0.left.equalTo(releaseSubTitleLabel)
            $0.right.equalTo(releaseSubTitleLabel)
            $0.height.equalTo(41)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        releaseMangerConfirmTitleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
}


extension HomeReleaseStudyListCell: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        
        reactor.state
            .map { $0.releaseModel.releaseTitle }
            .observe(on: MainScheduler.instance)
            .bind(to: releaseTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
}


