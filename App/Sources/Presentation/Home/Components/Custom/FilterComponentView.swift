//
//  FilterComponentView.swift
//  App
//
//  Created by Kim dohyun on 2022/11/15.
//

import UIKit
import Then
import SnapKit
import ReactorKit

import COCommonUI

final class FilterComponentViewReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var titleType: String
        var filterType: BottomSheetType
    }
    
    enum Mutation {
        case setOnOffLineFilter(String)
    }
    
    var initialState: State
    
    init(filterType: BottomSheetType) {
        self.initialState = State(titleType: "전체", filterType: filterType)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let formSheetTypeMutation = PostFilterTransform.event.flatMap { [weak self] event in
            self?.didTapBottomSheetTransform(from: event) ?? .empty()
        }
        return Observable.of(mutation, formSheetTypeMutation).merge()
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setOnOffLineFilter(titleType):
            var newState = state
            newState.titleType = titleType
            
            return newState
        }
    }
    
    
}


private extension FilterComponentViewReactor {
    
    func didTapBottomSheetTransform(from event: PostFilterTransform.Event) -> Observable<Mutation> {
        let currentState = self.currentState.filterType
        switch event {
        case let .didTapOnOffLineSheet(text):
            guard currentState == .onOffLine(.default) else { return .empty() }
            print("Transoform bottomSheet \(currentState)")
            return .just(.setOnOffLineFilter(text))
        default:
            return .empty()
        }
    }
    
    
}


final class FilterComponentView: BaseView {
    
    //MARK: Property
    typealias Reactor = FilterComponentViewReactor
    
    private let titleLabel: UILabel = UILabel().then {
        $0.text = "전체"
        $0.textColor = .hex3A3A3A
        $0.font = .regular(size: 12)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    private let arrImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_downward_arrow")
    }
    
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor}
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        _ = [titleLabel, arrImageView].map {
            self.addSubview($0)
        }
        
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalTo(arrImageView.snp.left).offset(-3)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        arrImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.right.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        }
        
    }
    
}


extension FilterComponentView: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        
        reactor.state
            .map { $0.titleType }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        
    }
    
}
