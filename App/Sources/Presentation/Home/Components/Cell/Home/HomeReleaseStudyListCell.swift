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
import RxCocoa
import RxGesture


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
        $0.numberOfLines = 0
        $0.sizeToFit()
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
        $0.backgroundColor = .hex028236
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    private let releaseMangerConfirmTitleLabel: UILabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 16)
        $0.text = "담당자와 채팅하기"
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
        releaseMangerConfirmView.addSubview(releaseMangerConfirmTitleLabel)
        releaseMangerConfirmView.isHidden = true
        
        _ = [releaseBookMarkCountLabel, releaseBookMarkImageView].map {
            self.releaseBookMarkContainerView.addSubview($0)
        }
        
        _ = [releaseTitleLabel,releaseSubTitleLabel,releaseBookMarkContainerView, releaseStateContainerView, releaseMemberStateLabel, releaseMemberStateImageView,releaseMangerConfirmView ].map {
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
            $0.edges.equalToSuperview().inset(3)
        }
        
        releaseBookMarkContainerView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(15)
            $0.height.equalTo(20)
            $0.width.equalTo(50)
        }
        
        releaseBookMarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.right.equalToSuperview()
        }
        
        releaseBookMarkCountLabel.snp.makeConstraints {
            $0.height.equalTo(17)
            $0.right.equalTo(releaseBookMarkImageView.snp.left).offset(-5)
            $0.centerY.equalTo(releaseBookMarkImageView)
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
        }
        
        releaseMemberStateImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-14)
            $0.left.equalTo(releaseSubTitleLabel)
            $0.width.height.equalTo(16)
        }
        
        releaseMemberStateLabel.snp.makeConstraints {
            $0.left.equalTo(releaseMemberStateImageView.snp.right).offset(5)
            $0.height.equalTo(14)
            $0.centerY.equalTo(releaseMemberStateImageView)
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
        
        releaseBookMarkContainerView
            .rx.tapGesture()
            .when(.recognized)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.didTapBookMarkButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        
        reactor.state
            .map { $0.releaseModel.releaseTitle }
            .observe(on: MainScheduler.instance)
            .bind(to: releaseTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.releaseModel.releaseisEnd }
            .map { _ in UIColor.hex8E8E8E }
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseStateContainerView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.releaseModel.releaseisEnd == false }
            .map { _ in UIColor.hex05A647 }
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseStateContainerView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.releaseModel.releaseisEnd == false }
            .map { _ in "모집중"}
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseStateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.releaseModel.releaseisEnd }
            .map { _ in "모집완료" }
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseStateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { String($0.releaseModel.releaseBookMark) }
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseBookMarkCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.releaseModel.releaseStudyInfo }
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseSubTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.releaseModel.releaseRecruitPart.map { parts -> String in
                switch parts.role {
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
            }.toStringWithVeticalBar}
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseMemberStateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.releaseModel.releaseMyBookMark }
            .map { _ in UIImage(named: "home_studylist_bookmark_select") }
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.releaseModel.releaseMyBookMark == false }
            .map { _ in UIImage(named: "home_studylist_bookmark") }
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .filter { $0.bookMarkModel != nil}
            .filter { $0.bookMarkModel!.bookMarkId == $0.releaseModel.id && $0.bookMarkModel!.bookMarkisCheck }
            .map { _ in UIImage(named: "home_studylist_bookmark_select") }
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.bookMarkModel?.bookMarkId == $0.releaseModel.id && $0.bookMarkModel?.bookMarkisCheck == false }
            .map { _ in UIImage(named: "home_studylist_bookmark")}
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.bookMarkModel?.bookMarkId == $0.releaseModel.id  }
            .map { String($0.bookMarkModel?.bookMarkCount ?? 0)}
            .observe(on: MainScheduler.instance)
            .bind(to: self.releaseBookMarkCountLabel.rx.text)
            .disposed(by: disposeBag)
            
    }
    
}


