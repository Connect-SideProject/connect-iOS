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
    case all = "전체"
    case project = "프로젝트"
    case study = "스터디"
    
    func getTitle() -> String {
        self.rawValue
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
    }
    
}


final class HomeStudyMenuCell: UICollectionViewCell {
    
    //MARK: Property
    
    typealias Reactor = HomeStudyMenuReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let studyMenuButton: UIButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.titleLabel?.textColor = .black
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
        self.contentView.addSubview(studyMenuButton)
        self.backgroundColor = .black
        studyMenuButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}



extension HomeStudyMenuCell: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.menuType.getTitle()}
            .debug("StudyMenu Cell")
            .observe(on: MainScheduler.instance)
            .bind(to: self.studyMenuButton.rx.title())
            .disposed(by: disposeBag)
    }
    
}
