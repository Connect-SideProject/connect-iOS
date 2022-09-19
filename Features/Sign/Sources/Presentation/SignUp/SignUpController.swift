//
//  SignUpController.swift
//  Sign
//
//  Created by sean on 2022/09/06.
//

import UIKit

import COCommonUI
import CODomain
import COExtensions
import ReactorKit

public final class SignUpController: UIViewController, ReactorKit.View {
  
  private let nicknameContainerView = DescriptionContainerView(
    type: .textField("닉네임", "닉네임을 입력하세요.")
  )
  
  private let locationContainerView = DescriptionContainerView(
    type: .textField("활동지역", "활동지역을 검색해주세요.")
  )
  
  private let periodContainerView = DescriptionContainerView(
    type: .custom("경력기간", CheckBoxContainerView(
        titles: [Career.aspirant.description, Career.junior.description, Career.senior.description],
        eventType: .radio
      )
    )
  )
  
  private let interestsContainerView = DescriptionContainerView(
    type: .custom("관심분야", SelectionButtonView(
      titles: [Interestring.finance.description,
               Interestring.fashion.description,
               Interestring.entertainment.description,
               Interestring.health.description]
      )
    )
  )
  
  private let jobContainerView = DescriptionContainerView(
    type: .custom("원하는 역할", SelectionButtonView(titles: ["기획자", "개발자", "디자이너", "마케터"]))
  )
  
  private let portfolioContainerView = DescriptionContainerView(
    type: .textField("포트폴리오", "포트폴리오 URL을 입력 해주세요. (선택)")
  )
  
  private let skillContainerView = DescriptionContainerView(
    type: .custom("보유 스킬", SelectionButtonView(titles: ["iOS", "Android", "Backend", "Frontend"]))
  )
  
  private let upper14YearsOldCheckBoxView = CheckBoxSingleView(
    title: "만 14세 이상임을 확인합니다."
  )
  
  private let acceptAllCheckBoxView = CheckBoxSingleView(
    title: "모든 필수 이용약관에 동의합니다."
  )
  
  private let termsCheckBoxContainerView = CheckBoxContainerView(
    titles: [Terms.service.description, Terms.privacy.description, Terms.location.description],
    direction: .vertical
  ).then {
    $0.backgroundColor = .lightGray
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
  }
  
  private lazy var startButton = RoundRutton().then {
    $0.setTitle("시작하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    $0.backgroundColor = .lightGray
    $0.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
  }
  
  private let containerScrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
  }
  
  private let flexContainer = UIView()
  
  public var disposeBag = DisposeBag()
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    flexContainer.pin
      .width(of: view)
      .height(of: view)
      .top(CGFloat(UIApplication.keyWindow?.safeAreaInsets.top ?? 0))
      .left().right()
      .layout()
    
    flexContainer.flex.layout()
    
    containerScrollView.pin
      .all()
      .layout()
    
    containerScrollView.contentSize = .init(
      width: flexContainer.frame.size.width,
      height: flexContainer.frame.size.height + 100
    )
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    bindEvent()
  }
  
  public func bind(reactor: SignUpReactor) {
    
  }
}

extension SignUpController {
  private func configureUI() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    view.backgroundColor = .white
    
    containerScrollView.addSubview(flexContainer)
    
    view.addSubview(containerScrollView)
    
    flexContainer.flex
      .marginHorizontal(20)
      .define { flex in
        
        [nicknameContainerView,
         locationContainerView,
         periodContainerView,
         interestsContainerView,
         jobContainerView,
         skillContainerView,
         portfolioContainerView
        ].forEach {
          flex.addItem($0)
            .marginBottom(20)
        }
        
        [upper14YearsOldCheckBoxView,
         acceptAllCheckBoxView].forEach {
          flex.addItem($0)
            .marginTop(8)
            .height(26)
        }
        
        flex.addItem(termsCheckBoxContainerView)
          .marginVertical(20)
          .marginLeft(10)
          .marginBottom(40)
          .height(110)
        
        flex.addItem(startButton)
          .marginHorizontal(20)
          .height(50)
    }
  }
  
  private func bindEvent() {
    termsCheckBoxContainerView.handler = { [weak self] checkItems in
      print(checkItems)
      
      if checkItems.count == 3 {
        self?.acceptAllCheckBoxView.setChecked(true)
      } else {
        self?.acceptAllCheckBoxView.setChecked(false)
      }
    }
    
    acceptAllCheckBoxView.handler = { [weak self] isChecked in
      self?.termsCheckBoxContainerView.checkedAll()
    }
  }
  
  @objc func didTapStartButton() {
    
    let nickname = nicknameContainerView.textField.text ?? ""
    let location = locationContainerView.textField.text ?? ""
    
    guard let period = periodContainerView.customView as? CheckBoxContainerView,
          let checkedItems = period.checkedItems else { return }

    let interesting: [Interestring] = (interestsContainerView.customView as! SelectionButtonView).selectedItems.map { Interestring(rawValue: $0) ?? .none }
    
    let carrer: Career = .init(rawValue: checkedItems[safe: 0]?.title ?? "") ?? .none
    let role: [Role] = (jobContainerView.customView as! SelectionButtonView).selectedItems.map { Role(rawValue: $0) ?? .none }
    
    let terms: [Terms] = termsCheckBoxContainerView.checkedItems?.map { Terms(rawValue: $0.title) ?? .none } ?? []
    
    let parameter: SignUpParameter = .init(
      authType: .kakao,
      nickname: nickname,
      region: .init(state: "", city: ""),
      interesting: interesting,
      career: carrer,
      role: role,
      profileURL: nil,
      portfolioURL: "",
      skills: [""],
      terms: terms
    )
    
    reactor?.action.onNext(.didTapSignUpButton(parameter))
  }
}
