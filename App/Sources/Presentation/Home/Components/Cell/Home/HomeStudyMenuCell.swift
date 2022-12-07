//
//  HomeStudyMenuCell.swift
//  connect
//
//  Created by Kim dohyun on 2022/09/28.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa

enum HomeSubMenuType: String {
    case all
    case project
    case study
    
    func getTitle() -> String {
        switch self {
        case .all: return "전체"
        case .project: return "프로젝트"
        case .study: return "스터디"
        }
    }
}

public final class HomeStudyMenuReactor: Reactor {
    

    public typealias Action = NoAction
    
    public var initialState: State
    
    public enum Mutation {
        case setSelected(type: Bool)
    }
    
    public struct State {
        var menuType: HomeSubMenuType
        var isSelected: Bool
    }
    
    init(menuType: HomeSubMenuType, isSelected: Bool) {
        defer { _ = self.state }
        self.initialState = State(menuType: menuType, isSelected: isSelected)
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setSelected(isSelected):
            var newState = state
            newState.isSelected = isSelected
            return newState
        }
    }
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromHomeMenuSelectMutation = HomeViewTransform.event.flatMap { [weak self] event in
            self?.didSelectHomeMenu(from: event) ?? .empty()
        }
        return Observable.of(mutation, fromHomeMenuSelectMutation).merge()
    }
    
}


private extension HomeStudyMenuReactor {
    func didSelectHomeMenu(from event: HomeViewTransform.Event) -> Observable<Mutation> {
        
        let state = self.currentState.menuType.rawValue
        
        switch event {
        case let .didSelectHomeMenu(type):
            return .just(.setSelected(type: state == type.currentState.menuType.rawValue))
        }
    }
}


final class HomeStudyMenuCell: UICollectionViewCell {
    
    //MARK: Property
    
    typealias Reactor = HomeStudyMenuReactor
    
    var disposeBag: DisposeBag = DisposeBag()
        
    private let studyMenuContainerView: UIView = UIView().then {
        $0.backgroundColor = UIColor.white
    }
    
    private let studyMenuTitleLabel: UILabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.textColor = UIColor.hex8E8E8E
    }
    
    
    private let selectedLineView: UIView = UIView().then {
        $0.backgroundColor = UIColor.hex06C755
    }
    
    
    //MARK: initalization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print(#function)
    }
    
    
    //MARK: Configure
    private func configure() {
        studyMenuContainerView.addSubview(studyMenuTitleLabel)
        
        _ = [studyMenuContainerView,selectedLineView].map {
            self.contentView.addSubview($0)
        }
        
        
        studyMenuContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyMenuTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(19)
        }
        
        selectedLineView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }

}



extension HomeStudyMenuCell: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        
        
        reactor.state.map { $0.menuType.getTitle()}
            .bind(to: studyMenuTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
                
        reactor.state.filter { $0.isSelected }
            .map { _ in UIColor.hex3A3A3A }
            .bind(to: self.studyMenuTitleLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        reactor.state.filter { $0.isSelected == false }
            .map { _ in UIColor.hex8E8E8E }
            .bind(to: self.studyMenuTitleLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.isSelected }
            .map { !$0 }
            .distinctUntilChanged()
            .bind(to: self.selectedLineView.rx.isHidden)
            .disposed(by: self.disposeBag)
            
        
    }
    
}
