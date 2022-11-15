//
//  FilterComponentView.swift
//  App
//
//  Created by Kim dohyun on 2022/11/15.
//

import UIKit
import Then
import SnapKit


final class FilterComponentView: BaseView {
    
    //MARK: Property
    
    private let titleLabel: UILabel = UILabel().then {
        $0.text = "전체"
        $0.textColor = .hex3A3A3A
        $0.font = .regular(size: 12)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    private let arrImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ic_downward_arrow")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        _ = [titleLabel, arrImageView].map {
            self.addSubview($0)
        }
        
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalTo(arrImageView.snp.left).offset(-3)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(14)
        }
        
        arrImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.right.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
        }
        
    }
    
}
