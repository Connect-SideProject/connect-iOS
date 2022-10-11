//
//  BottomSheetCell.swift
//  connectTests
//
//  Created by Kim dohyun on 2022/09/01.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa


final class BottomSheetCell: UITableViewCell {
    
    typealias Reactor = BottomSheetCellReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let checkImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "bottom_components_check")
    }
    
    private let typeTitleLabel: UILabel = UILabel().then {
        $0.textColor = .gray04
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        _ = [checkImageView,typeTitleLabel].map {
            self.contentView.addSubview($0)
        }
        
        typeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(17)
            $0.centerY.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.left.equalTo(typeTitleLabel.snp.right).offset(7)
            $0.width.equalTo(10)
            $0.height.equalTo(9)
            $0.centerY.equalToSuperview()
        }
        
    }
    
}


extension BottomSheetCell: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        reactor.state.map { $0.menuType }
            .debug("Reactor Cell Bind ")
            .bind(to: self.typeTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
