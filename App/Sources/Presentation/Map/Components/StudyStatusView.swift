//
//  StudyStatusView.swift
//  App
//
//  Created by 이건준 on 2022/11/01.
//

import UIKit
import SnapKit
import Then

enum StudyStatus {
    case 모집중
    case 모집완료
    
    var statusToString: String {
        switch self {
            case .모집중:
                return "모집중"
            case .모집완료:
                return "모집완료"
        }
    }
}

class StudyStatusView: UILabel {
    
    private let status: StudyStatus
    
    init(status: StudyStatus) {
        self.status = status
        super.init(frame: .zero)
        configureUI()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .green
        textColor = .white
        font = .systemFont(ofSize: 20, weight: .bold)
        text = status.statusToString
//        switch status {
//        case .모집중:
//
//        case .모집완료:
//            <#code#>
//        }
    }
}
