//
//  MyProfilePostListCell.swift
//  Profile
//
//  Created by Kim dohyun on 2022/12/11.
//

import UIKit
import SnapKit
import RxGesture
import ReactorKit

import CODomain
import COManager




final class MyProfilePostListCell: UICollectionViewCell {
    
    //MARK: Property
    
    typealias Reactor = MyProfilePostListCellReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let profilePostContainerView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
        $0.layer.borderColor = UIColor.hexEDEDED.cgColor
    }
    
    private let profilePostStateView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
    }
    
    private let profilePostStateLabel: UILabel = UILabel().then {
        $0.font = .medium(size: 11)
        $0.textAlignment = .center
        $0.textColor = .white
        $0.sizeToFit()
    }
    
    private let profilePostTitleLabel: UILabel = UILabel().then {
        $0.font = .semiBold(size: 16)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let profilePostSubTitleLabel: UILabel = UILabel().then {
        $0.font = .regular(size: 14)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    
    private let profilePostMemberStateLabel: UILabel = UILabel().then {
        $0.textColor = .hex8E8E8E
        $0.font = .regular(size: 12)
        $0.textAlignment = .left
    }
    
    private let profilePostMemberImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_member")
    }
    
    private let profilePostBookMarkView: UIView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let profilePostBookMarkImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_bookmark")
    }
    
    
    
    
    //MARK: initalization
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
        
        profilePostStateView.addSubview(profilePostStateLabel)
        profilePostBookMarkView.addSubview(profilePostBookMarkImageView)
        
        self.contentView.addSubview(profilePostContainerView)
        
        _ = [profilePostStateView, profilePostTitleLabel, profilePostSubTitleLabel, profilePostMemberImageView,profilePostMemberStateLabel, profilePostBookMarkView
        ].map {
            profilePostContainerView.addSubview($0)
        }
        
        profilePostContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profilePostStateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(18)
            $0.width.equalTo(46)
        }
        
        profilePostStateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
        
        profilePostBookMarkView.snp.makeConstraints {
            $0.top.equalTo(profilePostStateView)
            $0.right.equalToSuperview().offset(-20)
            $0.left.greaterThanOrEqualTo(profilePostTitleLabel.snp.right).offset(5)
            $0.width.height.equalTo(20)
        }
        
        profilePostBookMarkImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profilePostSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profilePostStateView.snp.bottom).offset(8)
            $0.left.equalTo(profilePostStateView)
            $0.bottom.equalTo(profilePostMemberImageView.snp.top).offset(-10)
            $0.right.equalToSuperview().offset(-16)
        }
        
        profilePostTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profilePostStateView)
            $0.left.equalTo(profilePostStateView.snp.right).offset(10)
            $0.height.equalTo(19)
        }
        
        profilePostMemberImageView.snp.makeConstraints {
            $0.left.equalTo(profilePostStateView)
            $0.height.width.equalTo(16)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        profilePostMemberStateLabel.snp.makeConstraints {
            $0.left.equalTo(profilePostMemberImageView.snp.right).offset(5)
            $0.height.equalTo(14)
            $0.centerY.equalTo(profilePostMemberImageView)
        }
        
        
    }
    
    fileprivate func isBookMarkCheck(listEntity: ProfileStudy, bookMarkEntity: HomeBookMarkList?) -> Bool {
        guard let bookMarkEntity = bookMarkEntity else { return false }
        
        return listEntity.isBookMarkId(bookMarkEntity.bookMarkId) && bookMarkEntity.bookMarkisCheck
    }
    
    fileprivate func isNotBookMarkCheck(listEntity: ProfileStudy, bookMarkEntity: HomeBookMarkList?) -> Bool {
        guard let bookMarkEntity = bookMarkEntity else { return false }
        
        return listEntity.isBookMarkId(bookMarkEntity.bookMarkId) && bookMarkEntity.bookMarkisCheck == false
    }
    
}



extension MyProfilePostListCell: ReactorKit.View {
    func bind(reactor: Reactor) {
        
        profilePostBookMarkView
            .rx.tapGesture()
            .when(.recognized)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.didTapStudyBookMarkButton}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.myStudyModel.myStudyTitle}
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.myStudyModel.myStudyInfo}
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostSubTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.myStudyModel.myStudyisEnd }
            .map { _ in UIColor.hex8E8E8E}
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostStateView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.myStudyModel.myStudyisEnd == false }
            .map { _ in UIColor.hex05A647 }
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostStateView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.myStudyModel.myStudyisEnd }
            .map { _ in "모집완료"}
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostStateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.myStudyModel.myStudyisEnd == false }
            .map { _ in "모집중"}
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostStateLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.myStudyModel.setProfileStudyResultsParts() }
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostMemberStateLabel.rx.text)
            .disposed(by: disposeBag)
        reactor.state
            .filter { $0.myStudyModel.myStudyisBookMark }
            .map { _ in UIImage(named: "home_studylist_bookmark_select")}
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.myStudyModel.myStudyisBookMark == false }
            .map { _ in UIImage(named: "home_studylist_bookmark") }
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { self.isBookMarkCheck(listEntity: $0.myStudyModel, bookMarkEntity: $0.myStudyBookMarkList)}
            .map { _ in UIImage(named: "home_studylist_bookmark_select")}
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { self.isNotBookMarkCheck(listEntity: $0.myStudyModel, bookMarkEntity: $0.myStudyBookMarkList)}
            .map { _ in UIImage(named: "home_studylist_bookmark") }
            .observe(on: MainScheduler.instance)
            .bind(to: profilePostBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
}
