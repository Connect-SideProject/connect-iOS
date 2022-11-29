//
//  PostFilterHeaderView.swift
//  AppTests
//
//  Created by Kim dohyun on 2022/11/14.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxGesture
import RxSwift
import RxCocoa
import COCommonUI

final class PostFilterReactor: Reactor {
    
    typealias Action = NoAction
    
    
    struct State {
        var isSelected: Bool
        var bottomSheetItem: [BottomSheetItem]
    }
    
    enum Mutation {
        case setSheetItems([BottomSheetItem])
    }
    
    var initialState: State
    
    init(bottomSheetItem: [BottomSheetItem]) {
        defer { _ = self.state }
        self.initialState = State(isSelected: false, bottomSheetItem: bottomSheetItem)
        print("PostFilter Reactor: \(bottomSheetItem)")
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromSheetItemMutation = PostFilterTransform.event.flatMap { [weak self] event in
            self?.responseSheetItemTransform(from: event) ?? .empty()
        }
        
        return Observable.of(mutation, fromSheetItemMutation).merge()
    }
    

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setSheetItems(items):
            var newState = state
            newState.bottomSheetItem = items
            
            return newState
        }
    }
}

private extension PostFilterReactor {
    func responseSheetItemTransform(from event: PostFilterTransform.Event) -> Observable<Mutation> {
        switch event {
        case let .responseSheetItem(item):
            print("PostFilterReactor Transform Item: \(item)")
            
            return .just(.setSheetItems(item))
            
        default:
            return .empty()
        }
        
    }
}




final class PostFilterHeaderView: BaseView {
    
    typealias Reactor = PostFilterReactor
    
    weak var delegate: PostCoordinatorDelegate?
    
    
    //MARK: Property
    private lazy var studyFilterStackView: UIStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = 10
        $0.axis = .horizontal
    }
    
    private let onOffLineFilterView: UIView = UIView().then {
        $0.backgroundColor = .hexEDEDED
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }

    private let studyTypeFilterView: UIView = UIView().then {
        $0.backgroundColor = .hexEDEDED
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private let interestFieldFilterView: UIView = UIView().then {
        $0.backgroundColor = .hexEDEDED
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private let alignmentFilterView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .hexEDEDED
    }
    
    private let onOffLineFilterComponentView: FilterComponentView = FilterComponentView(reactor: FilterComponentViewReactor(filterType: .onOffLine(.default)))
    
    private let studyTypeFilterComponentView: FilterComponentView = FilterComponentView(reactor: FilterComponentViewReactor(filterType: .studyType(.default)))
    
    private let interestFieldFilterComponentView: FilterComponentView = FilterComponentView(reactor: FilterComponentViewReactor(filterType: .interest([])))
    
    private let alignmentFilterComponentView: FilterComponentView = FilterComponentView(reactor: FilterComponentViewReactor(filterType: .aligment(.default)))
    
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    private func configure() {
        self.backgroundColor = .white
        
        onOffLineFilterView.addSubview(onOffLineFilterComponentView)

        studyTypeFilterView.addSubview(studyTypeFilterComponentView)

        interestFieldFilterView.addSubview(interestFieldFilterComponentView)

        alignmentFilterView.addSubview(alignmentFilterComponentView)


        _ = [onOffLineFilterView, studyTypeFilterView, interestFieldFilterView,alignmentFilterView].map {
            self.studyFilterStackView.addArrangedSubview($0)
        }
        
        self.addSubview(studyFilterStackView)
        
        studyFilterStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.height.equalTo(28)
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }

        
        onOffLineFilterComponentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        
        studyTypeFilterComponentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        interestFieldFilterComponentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alignmentFilterComponentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    
    
}



extension PostFilterHeaderView: ReactorKit.View {
    
    func bind(reactor: Reactor) {
        
        onOffLineFilterView
            .rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind { _ in
                self.delegate?.didFilterSheetCreate(.onOffLine(.default))
            }.disposed(by: disposeBag)
        
        studyTypeFilterView
            .rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind { _ in
                self.delegate?.didFilterSheetCreate(.studyType(.default))
            }.disposed(by: disposeBag)
        
        interestFieldFilterComponentView
            .rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind { _ in
                self.delegate?.didFilterSheetCreate(.interest(self.reactor?.currentState.bottomSheetItem ?? []))
            }.disposed(by: disposeBag)
        
        alignmentFilterView
            .rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind { _ in
                self.delegate?.didFilterSheetCreate(.aligment(.default))
            }.disposed(by: disposeBag)
        
    }
    
}

