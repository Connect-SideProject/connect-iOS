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

final class PostFilterReactor: Reactor {
    
    typealias Action = NoAction
    
    
    struct State {
        var isSelected: Bool
    }
    
    var initialState: State
    
    init() {
        defer { _ = self.state }
        self.initialState = State(isSelected: false)
    }
    
    
    
}




final class PostFilterHeaderView: BaseView {
    
    typealias Reactor = PostFilterReactor
    
    
    //MARK: Property
    private lazy var studyFilterStackView: UIStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = 10
        $0.axis = .horizontal
    }
    
    private let onOffLineFilterView: UIView = UIView().then {
        $0.backgroundColor = .hexEDEDED
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let onOffLineFilterLabel: UILabel = UILabel().then {
        $0.text = "전체"
        $0.textColor = .hex3A3A3A
        $0.font = .regular(size: 12)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    private let onOffLineArrowImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_downward_arrow")
    }
    
    private let studyTypeFilterView: UIView = UIView().then {
        $0.backgroundColor = .hexEDEDED
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let studyTypeFilterLabel: UILabel = UILabel().then {
        $0.textColor = .hex3A3A3A
        $0.font = .regular(size: 12)
        $0.text = "전체"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    private let studyTypeArrowImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_downward_arrow")
    }
    
    private let interestFieldFilterView: UIView = UIView().then {
        $0.backgroundColor = .hexEDEDED
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let interestFieldFilterLabel: UILabel = UILabel().then {
        $0.text = "전체"
        $0.font = .regular(size: 12)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.textColor = .hex3A3A3A
    }
    
    private let interestFieldArrowImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_downward_arrow")
    }
    
    private let alignmentFilterView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .hexEDEDED
    }
    
    private let alignmentFilterLabel: UILabel = UILabel().then {
        $0.text = "전체"
        $0.font = .regular(size: 12)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.textColor = .hex3A3A3A
    }
    
    private let alignmentArrowImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_downward_arrow")
    }
    
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    private func configure() {
        
        _ = [onOffLineFilterLabel ,onOffLineArrowImageView].map {
            onOffLineFilterView.addSubview($0)
        }
        
        _ = [studyTypeFilterLabel, studyTypeArrowImageView].map {
            studyTypeFilterView.addSubview($0)
        }
        
        _ = [interestFieldFilterLabel, interestFieldArrowImageView].map {
            interestFieldFilterView.addSubview($0)
        }
        
        _ = [alignmentFilterLabel, alignmentArrowImageView].map {
            alignmentFilterView.addSubview($0)
        }

        
        _ = [onOffLineFilterView, studyTypeFilterView, interestFieldFilterView,alignmentFilterView].map {
            self.studyFilterStackView.addArrangedSubview($0)
        }
        
        onOffLineFilterLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.right.equalTo(onOffLineArrowImageView.snp.left).offset(3)
            $0.height.equalTo(14)
        }
        
        onOffLineArrowImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.width.height.equalTo(20)
            $0.right.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        
        
        
        
    }
    
    
    
}



extension PostFilterHeaderView: ReactorKit.View {
    
    func bind(reactor: Reactor) {
        
    }
    
}

