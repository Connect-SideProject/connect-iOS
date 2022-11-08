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
import COManager
import ReactorKit
import RxCocoa

public protocol SignUpDelegate: AnyObject {
  func routeToMain()
}

public final class SignUpController: UIViewController, ReactorKit.View {
  
  enum Height {
    static let scrollView: CGFloat = 720 + (UIDevice.current.hasNotch ? 0 : 240)
  }
  
  private let nicknameContainerView = DescriptionContainerView(
    type: .textFieldWithAttributed(
      .init(
        attributedTitle: "닉네임 *".setLastWord(color: .red),
        placeholder: "닉네임을 입력하세요."
      )
    )
  )
  
  private lazy var addressContainerView = DescriptionContainerView(
    type: .customWithAttributed(
      .init(
        attributedTitle: "활동지역 *".setLastWord(color: .red),
        castableView: CastableButton(type: .downwordArrow("활동 지역을 선택해주세요.")),
        noticeText: "마이>설정 에서 공개여부를 선택할 수 있어요."
      )
    )
  )
  
  private let periodContainerView = DescriptionContainerView(
    type: .customWithAttributed(
      .init(
        attributedTitle: "경력기간 *".setLastWord(color: .red),
        castableView: CheckBoxContainerView(
          titles: [
            Career.aspirant.description,
            Career.junior.description,
            Career.senior.description
          ],
          eventType: .radio
        )
      )
    )
  )
  
  private var interestTitles: [String] = []
  private lazy var interestsContainerView = DescriptionContainerView(
    type: .customWithAttributed(
      .init(
        attributedTitle: "관심분야 *".setLastWord(color: .red),
        castableView: RoundSelectionButtonView(titles: interestTitles),
        noticeText: "필수 3개를 선택해주세요"
      )
    )
  )
  
  private var roleTitles: [String] = []
  private lazy var roleContainerView = DescriptionContainerView(
    type: .customWithAttributed(
      .init(
        attributedTitle: "원하는 역할 *".setLastWord(color: .red),
        castableView: RoundSelectionButtonView(titles: roleTitles)
      )
    )
  )
  
  private var skillsViews: [CastableView] = []
  private lazy var skillContainerView = DescriptionContainerView(
    type: .customWithAttributed(
      .init(
        attributedTitle: "보유 스킬 *".setLastWord(color: .red),
        castableView: CastableContainerView(views: skillsViews)
      )
    )
  )
  
  private let portfolioContainerView = DescriptionContainerView(
    type: .textField(
      .init(
        title: "포트폴리오",
        placeholder: "포트폴리오 URL을 입력 해주세요. (선택)"
      )
    )
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
    $0.backgroundColor = .hexF9F9F9
    $0.layer.cornerRadius = 5
    $0.layer.masksToBounds = true
  }
  
  private lazy var startButton = RoundRutton(
    cornerRadius: 5,
    borderColor: .hex028236
  ).then {
    $0.setTitle("커넥트잇 시작하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .medium(size: 16)
    $0.backgroundColor = .hex028236
    $0.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
  }
  
  private let containerScrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
  }
  
  private let flexContainer = UIView()
  
  public weak var delegate: SignUpDelegate?
  
  public var disposeBag = DisposeBag()
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    containerScrollView.pin
      .all()
      .layout()
    
    containerScrollView.contentSize = .init(
      width: view.bounds.size.width,
      height: view.bounds.size.height + Height.scrollView
    )
    
    flexContainer.pin
      .width(of: view)
      .height(view.bounds.size.height + Height.scrollView)
      .top()
      .left().right()
      .bottom(view.pin.safeArea)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    bindEvent()
    
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboards)
    )
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func dismissKeyboards() {
    nicknameContainerView.textField.resignFirstResponder()
    portfolioContainerView.textField.resignFirstResponder()
  }
  
  public func prefetch(interestList: [Interest], roleSkillsList: [RoleSkills]) {
    interestTitles = interestList.map { $0.name }
    roleTitles = roleSkillsList.map { $0.roleName }
    skillsViews = roleSkillsList.map {
      RoundSelectionButtonView(
        titles: $0.skills.map { $0.name },
        direction: .vertical
      )
    }
  }
  
  public func bind(reactor: SignUpReactor) {
    
    reactor.pulse(\.$route)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] route in
        switch route {
        case .home:
          self?.delegate?.routeToMain()
        case let .bottomSheet(items):
          let bottomSheet = BottomSheetController(
            type: .address(items)
          )
          bottomSheet.modalPresentationStyle = .overFullScreen
          bottomSheet.confirmHandler = { [weak self, weak reactor] selectedIndex in
            if let item = items[safe: selectedIndex] {
              let text = item.value.법정동명
              reactor?.action.onNext(.didSelectedLocation(selectedIndex))
              
              if let button = self?.addressContainerView.customView as? CastableButton {
                button.setTitle("서울 \(text)", for: .normal)
              }
            }
          }
          self?.present(bottomSheet, animated: true)
        }
      }.disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] error in
        guard let self = self else { return }
        switch error {
        case let .message(_, message):
          CommonAlert.shared.setMessage(.message(message))
            .show(viewController: self)
        default:
          break
        }
        
      }.disposed(by: disposeBag)
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
        
        flex.addItem(nicknameContainerView)
          .marginBottom(18)
        
        flex.addItem(addressContainerView)
          .marginBottom(18)
          .markDirty()

        [periodContainerView,
         interestsContainerView,
         roleContainerView,
         skillContainerView,
         portfolioContainerView
        ].forEach {
          flex.addItem($0)
            .marginBottom(18)
            .markDirty()
        }
        
        [upper14YearsOldCheckBoxView,
         acceptAllCheckBoxView].forEach {
          flex.addItem($0)
            .marginTop(4)
            .height(26)
        }
        
        flex.addItem(termsCheckBoxContainerView)
          .marginVertical(20)
          .marginBottom(20)
          .height(110)
        
        flex.addItem(startButton)
          .height(41)
    }
  }
  
  private func bindEvent() {

    if let castableButton = addressContainerView.customView as? CastableButton {
      castableButton.handler = { [weak reactor] in
        reactor?.action.onNext(.didTapAddressButton)
      }
    }
    
    termsCheckBoxContainerView.handler = { [weak self] checkItems in
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
    
    let period = periodContainerView.customView?.casting(
      type: CheckBoxContainerView.self
    ).checkedItems?.compactMap { $0 } ?? []
    
    let carrer: Career? = .init(
      description: period[safe: 0]?.title ?? ""
    )

    let interestings: [String] = interestsContainerView.customView?.casting(
      type: RoundSelectionButtonView.self
    ).selectedItems.compactMap { $0 } ?? []
    
    let roles: [RoleType] = roleContainerView.customView?.casting(
      type: RoundSelectionButtonView.self
    ).selectedItems.compactMap { RoleType(description: $0) } ?? []
    
    let portfolioURL = portfolioContainerView.textField.text
    
    let skills: [String] = skillContainerView.customView?.casting(
      type: CastableContainerView.self
    ).selectedItems.flatMap { $0 } ?? []
    
    let terms: [Terms] = termsCheckBoxContainerView
      .checkedItems?
      .compactMap { Terms(rawValue: $0.title) } ?? []
    
    let parameter: SignUpParameter = .init(
      nickname: nickname,
      interestings: interestings,
      career: carrer,
      roles: roles,
      portfolioURL: portfolioURL,
      skills: skills,
      terms: terms
    )
    
    reactor?.action.onNext(.didTapSignUpButton(parameter))
  }
}

extension SignUpController: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    
    let gestureDisableViews = [
      interestsContainerView.customView,
      roleContainerView.customView,
      skillContainerView.customView
    ]
    
    let isGestureDisabled = gestureDisableViews
      .compactMap { $0 }
      .filter { touch.view?.isDescendant(of: $0) ?? false }
      .count > 0
    
    if isGestureDisabled {
      return false
    }
    
    return true
  }
}
