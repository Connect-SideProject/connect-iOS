//
//  RoundSelectionButtonView.swift
//  COCommonUI
//
//  Created by sean on 2022/09/12.
//

import UIKit

import Then

public final class RoundSelectionButtonView: UIView, CastableView {
  
  private lazy var collectionViewLayout = LeftAlignedCollectionViewFlowLayout().then {
    $0.scrollDirection = direction
    $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout
  ).then {
    $0.register(RoundCollectionViewCell.self, forCellWithReuseIdentifier: "roundCell")
    $0.showsHorizontalScrollIndicator = false
    $0.dataSource = self
    $0.delegate = self
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  public private(set) var selectedItems: [String] = []
  public var handler: (String) -> Void = { _ in }
  
  private var dictionary: [String : Bool] = [:]
  private let titles: [String]
  private let isSelectable: Bool
  private let direction: UICollectionView.ScrollDirection
  
  /**
  라운드 형태의 선택버튼 생성자.

  - parameter titles: 선택버튼에 설정되는 타이틀.
  - parameter isSelectable: 버튼 선택가능 여부 / false: 선택되어있는 상태로 설정.
  - parameter direction: 버튼의 길이가 넘어가는경우 스크롤 및 보여지는 방향 설정.
  */
  public init(
    titles: [String],
    isSelectable: Bool = true,
    direction: UICollectionView.ScrollDirection = .horizontal
  ) {
    self.titles = titles
    self.isSelectable = isSelectable
    self.direction = direction
    super.init(frame: .zero)
    
    // 입력된 title만큼 dictionary 초기화
    let _ = titles.map {
      if isSelectable {
        self.dictionary[$0] = false
      } else {
        self.dictionary[$0] = true
        // 선택 비활성화 시 선택된 아이템에 추가.
        self.selectedItems.append($0)
      }
    }
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    endEditing(true)
  }
}

extension RoundSelectionButtonView {
  private func configureUI() {
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    
    if direction == .vertical {
      collectionView.isScrollEnabled = false
    }
    
    addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: self.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
}

extension RoundSelectionButtonView: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dictionary.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roundCell", for: indexPath) as? RoundCollectionViewCell {
      let title = titles[indexPath.item]
      if let isSelected = dictionary[title] {
        cell.configure(title: title, isSelected: isSelected)
      }
      return cell
    }
    
    return UICollectionViewCell()
  }
}

extension RoundSelectionButtonView: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard isSelectable else { return }
    
    let selectedTitle = titles[indexPath.item]
    
    dictionary[selectedTitle]?.toggle()
    
    if dictionary[selectedTitle] == true {
      selectedItems.append(selectedTitle)
    } else {
      selectedItems = selectedItems.filter { $0 != selectedTitle }
    }
    handler(selectedTitle)
    collectionView.reloadData()
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = titles[indexPath.item].size(
      withAttributes: [
        .font : UIFont.systemFont(ofSize: 14, weight: .semibold)
      ]
    ).width + 20
    
    return .init(width: width, height: 30)
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
}

final class RoundCollectionViewCell: UICollectionViewCell {
  
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textAlignment = .center
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 1
    
    layer.cornerRadius = 12
    layer.masksToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(title: String, isSelected: Bool) {
    titleLabel.text = title
    self.isSelected = isSelected
    
    backgroundColor = isSelected ? .black : .white
    titleLabel.textColor = isSelected ? .white : .black
  }
}

extension RoundCollectionViewCell {
  private func configureUI() {
    addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
}
