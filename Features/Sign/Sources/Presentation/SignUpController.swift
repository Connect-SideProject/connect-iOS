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
  func routeToHome()
}

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
  
  private var interestTitles: [String] = []
  private lazy var interestsContainerView = DescriptionContainerView(
    type: .custom("관심분야", RoundSelectionButtonView(titles: interestTitles))
  )
  
  private var roleTitles: [String] = []
  private lazy var roleContainerView = DescriptionContainerView(
    type: .custom("원하는 역할", RoundSelectionButtonView(titles: roleTitles))
  )
  
  private var skillsViews: [CastableView] = []
  private lazy var skillContainerView = DescriptionContainerView(
    type: .custom("보유 스킬", CastableContainerView(views: skillsViews))
  )
  
  private let portfolioContainerView = DescriptionContainerView(
    type: .textField("포트폴리오", "포트폴리오 URL을 입력 해주세요. (선택)")
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
  
  public weak var delegate: SignUpDelegate?
  
  public var disposeBag = DisposeBag()
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    containerScrollView.pin
      .all()
      .layout()
    
    containerScrollView.contentSize = .init(
      width: view.bounds.size.width,
      height: view.bounds.size.height + 660
    )
    
    flexContainer.pin
      .width(of: view)
      .height(containerScrollView.contentSize.height)
      .top(CGFloat(UIApplication.keyWindow?.safeAreaInsets.top ?? 0))
      .left().right()
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
    locationContainerView.textField.resignFirstResponder()
    portfolioContainerView.textField.resignFirstResponder()
  }
  
  public func bind(reactor: SignUpReactor) {
    
    Observable.just(())
      .map { Reactor.Action.viewDidLoad }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    locationContainerView.textField.rx.value
      .filter { !($0 ?? "").isEmpty }
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .debug()
      .flatMap { query -> Observable<Reactor.Action> in
        return .just(.searchAddress(query ?? ""))
      }.bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.interestList }
      .filter { !$0.isEmpty }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] interestList in
        self?.interestTitles = interestList.map { $0.name }
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.roleSkillsList }
      .filter { !$0.isEmpty }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] roleSkillsList in
        self?.roleTitles = roleSkillsList.map { $0.roleName }
        self?.skillsViews = roleSkillsList.map {
          RoundSelectionButtonView(
            titles: $0.skills.map { $0.name },
            direction: .vertical
          )
        }
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.route }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] route in
        switch route {
        case .home:
          self?.delegate?.routeToHome()
        }
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.error }
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
        
        [nicknameContainerView,
         locationContainerView,
         periodContainerView,
         interestsContainerView,
         roleContainerView,
         skillContainerView,
         portfolioContainerView
        ].forEach {
          flex.addItem($0)
            .marginBottom(18)
        }
        
        [upper14YearsOldCheckBoxView,
         acceptAllCheckBoxView].forEach {
          flex.addItem($0)
            .marginTop(4)
            .height(26)
        }
        
        flex.addItem(termsCheckBoxContainerView)
          .marginVertical(20)
          .marginLeft(10)
          .marginBottom(20)
          .height(110)
        
        flex.addItem(startButton)
          .marginHorizontal(20)
          .height(50)
    }
  }
  
  private func bindEvent() {
    
    skillContainerView.customView?.casting(
      type: CastableContainerView.self
    ).handler = {
      print($0)
    }
    
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
