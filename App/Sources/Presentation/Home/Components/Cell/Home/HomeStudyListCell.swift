//
//  HomeStudyListCell.swift
//  connect
//
//  Created by Kim dohyun on 2022/10/06.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxCocoa
import RxGesture

import CODomain


public final class HomeStudyListReactor: Reactor {

    public enum Action {
        case didTapNewsBookMark(String)
    }

    public struct State {
        var studyNewsModel: HomeStudyList?
        var studyNewsBookMarkModel: HomeBookMarkList?
    }
    
    public enum Mutation {
        case updateNewsBookMark(HomeBookMarkList)
    }
    
    public let initialState: State
    private let homeNewsRepo: HomeViewRepo?
    
    init(studyNewsModel: HomeStudyList?, homeNewsRepo: HomeViewRepo?) {
        defer { _ = self.state }
        self.initialState = State(studyNewsModel: studyNewsModel)
        self.homeNewsRepo = homeNewsRepo
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didTapNewsBookMark(id):
            let newsBookMarkMutaion = homeNewsRepo?.requestHomeNewsBookMarkItem(id: id)
            
            return newsBookMarkMutaion ?? .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .updateNewsBookMark(items):
            var newState = state
            newState.studyNewsBookMarkModel = items
            return newState
        }
        
    }

}






final class HomeStudyListCell: UICollectionViewCell {
    
    //MARK: Property
    
    typealias Reactor = HomeStudyListReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var emptyView: HomeEmptyView = HomeEmptyView()
    
    private let studyListContainerView: UIView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
        $0.layer.borderColor = UIColor.hexEDEDED.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let studyListStateView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
    }
    
    private let studyListStateLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = UIColor.white
        
    }
    
    private let studyListTitleLabel: UILabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let studyListSubTitleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let studyMemberStateLabel: UILabel = UILabel().then {
        $0.textColor = .hex8E8E8E
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textAlignment = .left
    }
    
    private let studyMemberImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "home_studylist_member")
    }
    
    private let studyBookMarkView: UIView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let studyBookMarkImageView: UIImageView = UIImageView().then {
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

        studyListStateView.addSubview(studyListStateLabel)
        studyBookMarkView.addSubview(studyBookMarkImageView)
        self.contentView.addSubview(studyListContainerView)
        self.contentView.addSubview(emptyView)
        
        _ = [studyListStateView,studyListTitleLabel,studyListSubTitleLabel,studyMemberImageView,studyMemberStateLabel,studyBookMarkView].map {
            studyListContainerView.addSubview($0)
        }
        
        
        studyListContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyListStateView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(18)
        }
        
        studyListStateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
        
        studyListTitleLabel.snp.makeConstraints {
            $0.top.equalTo(studyListStateView)
            $0.left.equalTo(studyListStateView.snp.right).offset(10)
            $0.height.equalTo(19)
        }
        
        studyBookMarkView.snp.makeConstraints {
            $0.top.equalTo(studyListStateView)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(20)
        }
        
        studyBookMarkImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyListSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(studyListStateView.snp.bottom).offset(8)
            $0.left.equalTo(studyListStateView)
            $0.right.equalToSuperview().offset(-16)
        }
        
        studyMemberImageView.snp.makeConstraints {
            $0.left.equalTo(studyListStateView)
            $0.height.width.equalTo(16)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        studyMemberStateLabel.snp.makeConstraints {
            $0.left.equalTo(studyMemberImageView.snp.right).offset(5)
            $0.height.equalTo(14)
            $0.centerY.equalTo(studyMemberImageView)
        }
        
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
}



extension HomeStudyListCell: ReactorKit.View {
    
    func bind(reactor: Reactor) {
        
        reactor.state
            .compactMap { $0.studyNewsModel}
            .map { $0.studyNewsTitle }
            .bind(to: studyListTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.studyNewsModel }
            .map { $0.studyNewsInfo }
            .bind(to: studyListSubTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.studyNewsModel}
            .filter { $0.studyNewsIsEnd }
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in
                self.studyListStateLabel.text = "모집중"
            }).map { _ in UIColor.hex05A647 }
            .bind(to: studyListStateView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.studyNewsModel?.studyNewsIsEnd == false }
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in
                self.studyListStateLabel.text = "모집완료"
            }).map { _ in UIColor.hex8E8E8E}
            .bind(to: studyListStateView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.studyNewsModel?.studyNewsParts.map { studyParts -> String in
                
                switch studyParts.studyRole {
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
            .bind(to: studyMemberStateLabel.rx.text)
            .disposed(by: disposeBag)
        
        guard let bookMarkId = self.reactor?.currentState.studyNewsModel?.id else { return }
        
        studyBookMarkView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.didTapNewsBookMark(String(bookMarkId))}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.studyNewsModel }
            .filter { $0.studyNewsMyBookMark }
            .map { _ in UIImage(named: "home_studylist_bookmark_select") }
            .observe(on: MainScheduler.instance)
            .bind(to: studyBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.studyNewsModel }
            .filter { $0.studyNewsMyBookMark == false }
            .map { _ in UIImage(named: "home_studylist_bookmark") }
            .observe(on: MainScheduler.instance)
            .bind(to: studyBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
            
        
        reactor.state
            .filter { $0.studyNewsBookMarkModel?.bookMarkId == $0.studyNewsModel?.id }
            .map { _ in UIImage(named: "home_studylist_bookmark_select") }
            .observe(on: MainScheduler.instance)
            .bind(to: studyBookMarkImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.studyNewsModel?.id != nil }
            .bind(to: emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
}
