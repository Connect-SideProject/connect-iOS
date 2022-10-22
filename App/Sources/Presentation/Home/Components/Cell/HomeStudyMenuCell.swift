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


final class HomeStudyMenuReactor: Reactor {
    

    typealias Action = NoAction
    
    var initialState: State
    
    struct State {
        var menuType: HomeSubMenuType
    }
    
    init(menuType: HomeSubMenuType) {
        defer { _ = self.state }
        self.initialState = State(menuType: menuType)
        print("study Menu Type: \(menuType)")
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
        $0.textColor = UIColor.gray04
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
        
        self.contentView.addSubview(studyMenuContainerView)
        
        
        studyMenuContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        studyMenuTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(19)
        }
    }

}



extension HomeStudyMenuCell: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        
        
        reactor.state.map { $0.menuType.getTitle()}
            .observe(on: MainScheduler.instance)
            .bind(to: studyMenuTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.menuType.getTitle() }
            .filter{ $0 == "전체" }
            .map { _ in UIColor.black }
            .bind(to: self.studyMenuTitleLabel.rx.textColor)
            .disposed(by: disposeBag)
        
    }
    
}
