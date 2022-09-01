//
//  BottomSheetSection.swift
//  connect
//
//  Created by Kim dohyun on 2022/08/30.
//

import RxDataSources


enum BottomSheetSection {
    case utilSection([BottomSheetSectionItem])
}

extension BottomSheetSection: SectionModelType {
    var items: [BottomSheetSectionItem] {
        switch self {
        case let .utilSection(items): return items
        }
    }
    
    
    init(original: BottomSheetSection, items: [BottomSheetSectionItem]) {
        switch original {
        case .utilSection: self = .utilSection(items)
        }
    }
}


enum BottomSheetSectionItem {
    case all(BottomSheetCellReactor)
    case online(BottomSheetCellReactor)
    case offline(BottomSheetCellReactor)
}
