//
//  MyProfileBookMarkListCell.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/13.
//

import UIKit
import SnapKit
import ReactorKit

import COManager



final class MyProfileBookMarkListCell: UICollectionViewCell {
    
    //MARK: Property
    
    typealias Reactor = MyProfileBookMarkListCellReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let profileBookMarkContainerView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
        $0.layer.borderColor = UIColor.hexEDEDED.cgColor
    }
    
    private let profileBookMarkStateView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
    }
    
    private let profileBookMarkStateLabel: UILabel = UILabel().then {
        $0.font = .medium(size: 11)
        $0.textAlignment = .center
        $0.textColor = .white
        $0.sizeToFit()
    }
    
    private let profileBookMarkTitleLabel: UILabel = UILabel().then {
        $0.font = .semiBold(size: 16)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let profileBookMarkSubTitleLable: UILabel = UILabel().then {
        $0.font = .regular(size: 14)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let profileBookMarkMemberStateLabel: UILabel = UILabel().then {
        $0.textColor = .hex8E8E8E
        $0.font = .regular(size: 12)
        $0.textAlignment = .left
    }
    
    private let profileBookMarkMemberImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_member")
    }
    
    private let profileBookMarkView: UIView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let profileBookMarkImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_bookmark_select")
    }
    
    
    //MARK: initalization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    private func configure() {
        profileBookMarkStateView.addSubview(profileBookMarkStateLabel)
        profileBookMarkView.addSubview(profileBookMarkImageView)
        
        self.contentView.addSubview(profileBookMarkContainerView)
        
        _ = [profileBookMarkStateView, profileBookMarkTitleLabel,
             profileBookMarkSubTitleLable, profileBookMarkMemberImageView,
             profileBookMarkMemberImageView, profileBookMarkMemberStateLabel,
             profileBookMarkView
        ].map {
            profileBookMarkContainerView.addSubview($0)
        }
        
        profileBookMarkContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileBookMarkStateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(18)
            $0.width.equalTo(46)
        }
        
        profileBookMarkStateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
        
        profileBookMarkView.snp.makeConstraints {
            $0.top.equalTo(profileBookMarkStateView)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
        
        profileBookMarkImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        profileBookMarkSubTitleLable.snp.makeConstraints {
            $0.top.equalTo(profileBookMarkStateView.snp.bottom).offset(8)
            $0.left.equalTo(profileBookMarkStateView)
            $0.right.equalToSuperview().offset(-16)
        }
        
        profileBookMarkTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileBookMarkStateView)
            $0.left.equalTo(profileBookMarkStateView.snp.right).offset(10)
            $0.height.equalTo(19)
        }
        
        profileBookMarkMemberImageView.snp.makeConstraints {
            $0.left.equalTo(profileBookMarkStateView)
            $0.height.width.equalTo(16)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        profileBookMarkMemberStateLabel.snp.makeConstraints {
            $0.left.equalTo(profileBookMarkMemberImageView.snp.right).offset(5)
            $0.height.equalTo(14)
            $0.centerY.equalTo(profileBookMarkMemberImageView)
        }
        
    }
    
    
    
}


extension MyProfileBookMarkListCell: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        
        reactor.state
            .map { $0.myBookMarkModel.myBookMarkTitle}
            .observe(on: MainScheduler.instance)
            .bind(to: profileBookMarkTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.myBookMarkModel.myBookMarkInfo}
            .observe(on: MainScheduler.instance)
            .bind(to: profileBookMarkSubTitleLable.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.myBookMarkModel.myBookMarkisEnd }
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in
                self.profileBookMarkStateLabel.text = "모집중"
            }).map { _ in UIColor.hex05A647}
            .bind(to: profileBookMarkStateView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .filter { $0.myBookMarkModel.myBookMarkisEnd == false }
            .do(onNext: { _ in
                self.profileBookMarkStateLabel.text = "모집완료"
            }).map { _ in UIColor.hex8E8E8E }
            .observe(on: MainScheduler.instance)
            .bind(to: profileBookMarkStateView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.myBookMarkModel.myBookMarkParts
                    .map { parts -> String in
                        switch parts.myStudyMemberRole {
                        case "DEV":
                            return "개발자"
                        case "DESIGN":
                            return "디자이너"
                        case "PM":
                            return "기획자"
                        case "MAK":
                            return "마케터"
                        default:
                            return ""
                        }
                    }.toStringWithVeticalBar
            }
            .observe(on: MainScheduler.instance)
            .bind(to: profileBookMarkMemberStateLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .filter { !$0.myBookMarkModel.myBookMarkisCheck }
            .map { _ in UIImage(named: "home_studylist_bookmark_select")}
            .observe(on: MainScheduler.instance)
            .bind(to: profileBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
}
