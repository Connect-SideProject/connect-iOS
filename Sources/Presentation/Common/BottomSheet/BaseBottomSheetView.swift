//
//  BaseBottomSheetView.swift
//  connect
//
//  Created by Kim dohyun on 2022/08/30.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxDataSources

enum BottomSheettTitle: String {
    case onOffLine = "온/오프라인"
    case aligment = "정렬"
    case studyType = "종류"
    
    struct sheetModel {
        var title: String
    }
    
    var sheetSectionModel: [sheetModel] {
        switch self {
        case .onOffLine:
            return [sheetModel(title: "전체"), sheetModel(title: "온라인"), sheetModel(title: "오프라인")]
        case .aligment:
            return [sheetModel(title: "전체"), sheetModel(title: "인기순"), sheetModel(title: "거리순")]
        case .studyType:
            return [sheetModel(title: "전체"), sheetModel(title: "스터디"), sheetModel(title: "프로젝트")]
        }
    }
}

enum onOffLineType: String {
    case all = "전체"
    case online = "온라인"
    case offLine = "오프라인"
}



class BaseBottomSheetView: UIViewController {
    
    
    //MARK: Property
    typealias Reactor = BottomSheetReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let dimView: UIView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private let containerView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    private let titleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    private let deleteButton: UIButton = UIButton().then {
        $0.setImage(UIImage(named: "bottom_top_delete"), for: .normal)
        $0.contentMode = .scaleToFill
    }
    
    private let confirmButton: UIButton = UIButton().then {
        $0.backgroundColor = .green06
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.setAttributedTitle(NSAttributedString(string: "적용하기", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]), for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
    }
    
    private let tableView: UITableView = UITableView().then {
        $0.register(BottomSheetCell.self, forCellReuseIdentifier: "BottomSheetCell")
        $0.separatorColor = .gray02
        $0.separatorInset = .zero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    init(sheetTitle: BottomSheettTitle, collectionType: BottomSheettTitle) {
        self.titleLabel.text = sheetTitle.rawValue
        defer { self.reactor = BottomSheetReactor(type: collectionType) }
        self.datasources = type(of: self).dataSourcesFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let datasources: RxTableViewSectionedReloadDataSource<BottomSheetSection>
    
    
    private static func dataSourcesFactory() -> RxTableViewSectionedReloadDataSource<BottomSheetSection> {
        return .init { datasource, tableView, indexPath, sectionItem in
            switch sectionItem {
            case let .all(cellRector):
                let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetCell", for: indexPath) as? BottomSheetCell
                cell?.reactor = cellRector
                
                return cell!
            default:
                return UITableViewCell()
            }
        }
    }
    
    private func configure() {
        
        self.view.addSubview(dimView)
        
        dimView.addSubview(containerView)
        
        _ = [tableView, titleLabel, deleteButton, confirmButton].map {
            containerView.addSubview($0)
        }
        
        dimView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(409)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(confirmButton.snp.top)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(18)
        }
        
        confirmButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(41)
        }
        
    }
    
}


extension BaseBottomSheetView: ReactorKit.View {
    
    
    func bind(reactor: Reactor) {
        
        self.rx.viewDidLoad
            .map { Reactor.Action.load }
            .bind(to: reactor.action )
            .disposed(by: disposeBag)
        
        
        
        self.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.section }
            .debug("BottomSheetCell")
            .observe(on: MainScheduler.instance)
            .bind(to: self.tableView.rx.items(dataSource: self.datasources))
            .disposed(by: disposeBag)
    }
    
}


extension BaseBottomSheetView: UITableViewDelegate {
    
    
}
