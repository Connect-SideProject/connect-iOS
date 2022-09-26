//
//  BottomSheetSection.swift
//  connect
//
//  Created by Kim dohyun on 2022/08/30.
//

import RxDataSources


enum BottomSheetSection {
    case utilSection([Item])
}

extension BottomSheetSection: SectionModelType {
    typealias Item = BottomSheetSectionItem
    
    
    var items: [Item] {
        switch self {
        case let .utilSection(items): return items
        }
    }
    
    
    init(original: BottomSheetSection, items: [Item]) {
        switch original {
        case .utilSection: self = .utilSection(items)
        }
    }
}


enum BottomSheetSectionItem {
    case all(BottomSheetCellReactor)
}
