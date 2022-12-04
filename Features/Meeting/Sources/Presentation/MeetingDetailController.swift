//
//  MeetingDetailController.swift
//  Meeting
//
//  Created by Taeyoung Son on 2022/12/04.
//

import UIKit

import RxSwift
import ReactorKit
import COCommonUI

public final class MeetingDetailController: ReactorBaseController<MeetingDetailController.Reactor> {
    private let titleView = TitleView()
    private let topArea = TopArea()
    private let tableView = UITableView()
}

extension MeetingDetailController {
    final public class Reactor: ReactorKit.Reactor {
        public var initialState = State()
        public enum Action { }
        public struct State { }
    }
}

extension MeetingDetailController {
    final class TopArea: FlexLayoutView {
        
    }
}

extension MeetingDetailController {
    final class CardTableCell: RxBaseTableCell<Any> {
        
    }
    
    final class TextTableCell: RxBaseTableCell<Any> {
        
    }
}
