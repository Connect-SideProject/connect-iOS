//
//  BottomSheetSection.swift
//  connect
//
//  Created by Kim dohyun on 2022/08/30.
//

import RxDataSources


enum BottomSheetSection<T> {
    case utilSection([BottomSheetSectionItem<T>])
}

extension BottomSheetSection: SectionModelType {
    var items: [BottomSheetSectionItem<T>] {
        switch self {
        case let .utilSection(items): return items
        }
    }
    
    
    init(original: BottomSheetSection, items: [BottomSheetSectionItem<T>]) {
        switch original {
        case .utilSection: self = .utilSection(items)
        }
    }
}


enum BottomSheetSectionItem<T> {
    case all(BottomSheetCellReactor<T>)
    case online(BottomSheetCellReactor<T>)
    case offline(BottomSheetCellReactor<T>)
}
