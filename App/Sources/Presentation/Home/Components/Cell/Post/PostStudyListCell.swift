//
//  PostStudyListCell.swift
//  App
//
//  Created by Kim dohyun on 2022/11/13.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxCocoa
import RxGesture


final class PostStduyListCell: UICollectionViewCell {
    
    
    //MARK: Property
    
    typealias Reactor = PostListCellReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    
    private let postContainerView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
        $0.layer.borderColor = UIColor.hexEDEDED.cgColor
        $0.layer.borderWidth = 1
    }
    
    
    private let postStateView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 2
    }
    
    private let postStateTitleLabel: UILabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.sizeToFit()
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    private let postTitleLabel: UILabel = UILabel().then {
        $0.textColor = .hex141616
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let postExplanationLabel: UILabel = UILabel().then {
        $0.textColor = .hex141616
        $0.font = .regular(size: 14)
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let postBookMarkContainerView: UIView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let postBookMarkImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "home_studylist_bookmark")
        $0.contentMode = .scaleToFill
    }
    
    private let postMemberImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "home_studylist_member")
        $0.contentMode = .scaleToFill
    }
    
    private let postMemberLabel: UILabel = UILabel().then {
        $0.font = .regular(size: 12)
        $0.textAlignment = .left
        $0.textColor = .hex8E8E8E
        $0.sizeToFit()
    }
    
    
    
    //MARK: initalization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    
    private func configure() {
        postStateView.addSubview(postStateTitleLabel)
        postBookMarkContainerView.addSubview(postBookMarkImageView)
        
        self.contentView.addSubview(postContainerView)
        
        
        _ = [postStateView, postTitleLabel, postExplanationLabel, postMemberImageView, postMemberLabel, postBookMarkContainerView].map {
            postContainerView.addSubview($0)
        }
        
        postContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        postStateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(18)
        }
        
        postStateTitleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalTo(postStateView)
            $0.left.equalTo(postStateView.snp.right).offset(10)
            $0.height.equalTo(19)
        }
        
        postBookMarkContainerView.snp.makeConstraints {
            $0.top.equalTo(postStateView)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
        
        postBookMarkImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        postExplanationLabel.snp.makeConstraints {
            $0.top.equalTo(postStateView.snp.bottom).offset(8)
            $0.left.equalTo(postStateView)
            $0.right.equalToSuperview().offset(-16)
        }
        
        postMemberImageView.snp.makeConstraints {
            $0.left.equalTo(postStateView)
            $0.height.width.equalTo(16)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        postMemberLabel.snp.makeConstraints {
            $0.left.equalTo(postMemberImageView.snp.right).offset(5)
            $0.height.equalTo(14)
            $0.centerY.equalTo(postMemberImageView)
        }
        
        
        
    }
    
    
}



extension PostStduyListCell: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        
        reactor.state
            .map { $0.postModel.contentStudyTitle }
            .observe(on: MainScheduler.instance)
            .bind(to: postTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.postModel.contentisEnd }
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { _ in
                self.postStateTitleLabel.text = "모집중"
            }).map { _ in UIColor.hex05A647 }
            .bind(to: postStateView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.postModel.contentisEnd == false }
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { _ in
                self.postStateTitleLabel.text = "모집완료"
            }).map { _ in UIColor.hex8E8E8E }
            .bind(to: postStateView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.postModel.contentStudyInfo}
            .observe(on: MainScheduler.instance)
            .bind(to: postExplanationLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.postModel.contentStudyParts.map { parts -> String in
                switch parts.contentStudyRole {
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
            .bind(to: postMemberLabel.rx.text)
            .disposed(by: disposeBag)
        
        guard let postBookMarkid = self.reactor?.currentState.postModel.id else { return }
        
            
        reactor.state
            .filter { $0.postModel.contentisBookMark  }
            .map { _ in UIImage(named: "home_studylist_bookmark_select") }
            .observe(on: MainScheduler.instance)
            .bind(to: postBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.postModel.contentisBookMark == false }
            .map { _ in UIImage(named: "home_studylist_bookmark") }
            .observe(on: MainScheduler.instance)
            .bind(to: postBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
            
        
        postBookMarkContainerView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.didTapPostBookMark(String(postBookMarkid))}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.postBookMarkItems?.bookMarkId == $0.postModel.id }
            .map { _ in UIImage(named: "home_studylist_bookmark_select")}
            .observe(on: MainScheduler.instance)
            .bind(to: postBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        
    }
}
