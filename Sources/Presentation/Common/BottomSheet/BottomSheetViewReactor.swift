//
//  BottomSheetViewReactor.swift
//  connectTests
//
//  Created by Kim dohyun on 2022/09/02.
//

import ReactorKit
import UIKit

final class BottomSheetReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setLoadItems(BottomSheetSection)
    }
    
    struct State {
        var isLoading: Bool
        var section: [BottomSheetSection]
        var type: BottomSheettTitle
    }
    
    init(type: BottomSheettTitle) {
        defer { _ = self.state }
        self.initialState = State(
            isLoading: false,
            section: [
                .utilSection([])
            ],
            type: type
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return .concat(
                .just(.setLoading(true)),
                .just(.setLoadItems(.utilSection([.all(BottomSheetCellReactor.init(menuType: self.currentState.type.sheetSectionModel))]))),
                .just(.setLoading(false))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            return newState
        case let .setLoadItems(items):
            var newState = state
            newState.section[0] = items
            
            return newState
        }
    }

}
