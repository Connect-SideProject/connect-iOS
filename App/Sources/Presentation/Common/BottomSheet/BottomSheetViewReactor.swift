//
//  BottomSheetViewReactor.swift
//  connectTests
//
//  Created by Kim dohyun on 2022/09/02.
//

import ReactorKit
import UIKit

enum aligmentBottomSheet: String {
    case all = "전체"
    case popularity = "인기순"
    case new = "최신순"
}

enum onOffLineBottomSheet: String {
    case all = "전체"
    case online = "온라인"
    case offline = "오프라인"
}

enum studyTypeBottomSheet: String {
    case all = "전체"
    case study = "스터디"
    case project = "프로젝트"
}


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
        var section: BottomSheetSection
        var type: BottomSheettTitle
    }
    
    init(type: BottomSheettTitle) {
        defer { _ = self.state }
        self.initialState = State(
            isLoading: false,
            section: .utilSection([]),
            type: type
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            if self.currentState.type == .aligment {
                let setAligmentItems = Observable<Mutation>.just(.setLoadItems(
                    .utilSection([.all(BottomSheetCellReactor(menuType: aligmentBottomSheet.all.rawValue)),
                                  .all(BottomSheetCellReactor(menuType: aligmentBottomSheet.popularity.rawValue)),
                                  .all(BottomSheetCellReactor(menuType: aligmentBottomSheet.new.rawValue))
                                 ])))
                return .concat([
                    startLoading,
                    setAligmentItems,
                    endLoading
                ])
            } else if self.currentState.type == .onOffLine {
                let setOnfflineItems = Observable<Mutation>.just(.setLoadItems(
                    .utilSection([.all(BottomSheetCellReactor(menuType: onOffLineBottomSheet.all.rawValue)),
                                  .all(BottomSheetCellReactor(menuType: onOffLineBottomSheet.online.rawValue)),
                                  .all(BottomSheetCellReactor(menuType: onOffLineBottomSheet.offline.rawValue))
                                 ])))
                
                return .concat([
                    startLoading,
                    setOnfflineItems,
                    endLoading
                ])
            } else {
                let setOnofflineItems = Observable<Mutation>.just(.setLoadItems(
                    .utilSection([.all(BottomSheetCellReactor(menuType: studyTypeBottomSheet.all.rawValue)),
                                  .all(BottomSheetCellReactor(menuType: studyTypeBottomSheet.study.rawValue)),
                                  .all(BottomSheetCellReactor(menuType: studyTypeBottomSheet.project.rawValue))
                    ])))
                return .concat([
                    startLoading,
                    setOnofflineItems,
                    endLoading
                ])
            }
            
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
            newState.section = items
            
            return newState
        }
    }

}
