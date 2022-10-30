//
//  BottomSheetController.swift
//  connect
//
//  Created by Kim dohyun on 2022/08/30.
//

import UIKit

import Then
import SnapKit
import CODomain
import COManager

public enum BottomSheetType: CustomStringConvertible {
  public var description: String {
    switch self {
    case .onOffLine:
      return "온/오프라인"
    case .aligment:
      return "정렬"
    case .studyType:
      return "종류"
    case .address:
      return "활동지역"
    }
  }
  
  case onOffLine
  case aligment
  case studyType
  case address([BottomSheetItem<법정주소>])
}

public struct BottomSheetItem<T> where T: Decodable {
  public let value: T
  public var isSelected: Bool = false
  
  public init(value: T) {
    self.value = value
  }
}

extension BottomSheetItem {
  mutating func update(isSelected: Bool) {
    self.isSelected = isSelected
  }
}

public final class BottomSheetController: UIViewController {
  
  private let dimView: UIView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private let containerView: UIView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 20
    $0.layer.maskedCorners = CACornerMask(
      arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner
    )
  }
  
  private let titleLabel: UILabel = UILabel().then {
    $0.font = .regular(size: 16)
    $0.textColor = .hex3A3A3A
    $0.textAlignment = .center
    $0.numberOfLines = 1
  }
  
  private lazy var closeButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_close"), for: .normal)
    $0.contentMode = .scaleToFill
    $0.addTarget(self, action: #selector(didTapCloseButotn), for: .touchUpInside)
  }
  
  private lazy var confirmButton: UIButton = UIButton().then {
    $0.setTitle("적용하기", for: .normal)
    $0.setTitleColor(UIColor.white, for: .normal)
    
    $0.backgroundColor = .hex028236
    $0.titleLabel?.font = .medium(size: 16)
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
    
    $0.addTarget(self, action: #selector(didTapConfirmButotn), for: .touchUpInside)
  }
  
  private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
    
    switch type {
    case .address:
      $0.itemSize = .init(
        width: (view.bounds.width - 52) / 2,
        height: 42
      )
    default:
      $0.itemSize = .init(
        width: view.bounds.width,
        height: 38
      )
    }
  }
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout
  ).then {
    $0.register(BottomSheetItemCell.self, forCellWithReuseIdentifier: "BottomSheetItemCell")
    $0.register(BottomSheetListCell.self, forCellWithReuseIdentifier: "BottomSheetListCell")
    $0.delegate = self
    $0.dataSource = self
    $0.contentInset = .init(top: 0, left: 0, bottom: 13, right: 0)
  }
  
  private let type: BottomSheetType
  private var items: [BottomSheetItem<법정주소>] = []
  
  public var confirmHandler: (Int) -> Void = { _ in }
  public var cancelHandler: () -> Void = {}
  
  public init(type: BottomSheetType) {
    self.type = type
    self.titleLabel.text = type.description
    
    switch type {
    case let .address(items):
      self.items = items
    default:
      break
    }
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    dimView.backgroundColor = .black.withAlphaComponent(0.5)
    
  }
}

private extension BottomSheetController {
  
  func configureUI() {
    
    self.view.backgroundColor = .clear
    self.view.addSubview(dimView)
    
    dimView.addSubview(containerView)
    
    let _ = [titleLabel, closeButton, collectionView, confirmButton].map {
      containerView.addSubview($0)
    }
    
    dimView.snp.makeConstraints {
      $0.top.left.right.bottom.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.height.equalTo(19)
      $0.centerX.equalToSuperview()
    }
    
    closeButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(21)
      $0.right.equalToSuperview().inset(20)
      $0.width.height.equalTo(18)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(confirmButton.snp.top).offset(-13)
    }
    
    confirmButton.snp.makeConstraints {
      $0.left.equalToSuperview().offset(20)
      $0.right.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview().offset(-24)
      $0.height.equalTo(41)
    }
    
    containerView.snp.makeConstraints {
      $0.bottom.left.right.equalToSuperview()
      $0.height.equalTo(409)
    }
  }
  
  @objc func didTapCloseButotn() {
    dimView.backgroundColor = .clear
    
    dismiss(animated: true)
  }
  
  @objc func didTapConfirmButotn() {
    dimView.backgroundColor = .clear
    
    dismiss(animated: true) { [weak self] in
      guard let self  = self else { return }
      
      let selectedIndex = self.items.enumerated()
        .map { offset, element in
          return element.isSelected ? offset : -1
        }
        .filter { $0 != -1 }
        .first
      
      if let selectedIndex = selectedIndex {
          self.confirmHandler(selectedIndex)
      }
    }
  }
}

extension BottomSheetController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomSheetItemCell", for: indexPath) as? BottomSheetItemCell {
      let item = items[indexPath.item]
      
      cell.setup(title: item.value.법정동명, isSelected: item.isSelected)
      return cell
    }
    
    return UICollectionViewCell()
  }
}

extension BottomSheetController: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if items[indexPath.item].isSelected == true {
      return
    }
    
    let _ = self.items.enumerated().map { offset, item in
      items[offset].update(isSelected: false)
    }
    
    items[indexPath.item].update(isSelected: true)
    
    collectionView.reloadData()
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 12
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
}
