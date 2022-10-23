//
//  ProfileEditController.swift
//  Profile
//
//  Created by sean on 2022/10/07.
//

import UIKit

import ReactorKit
import RxCocoa
import Then

import COCommonUI
import CODomain
import COExtensions
import COManager

public protocol ProfileEditDelegate: AnyObject {
  func routeToBack()
}

public final class ProfileEditController: UIViewController, ReactorKit.View {
  
  public typealias Reactor = ProfileEditReactor
  
  private lazy var profileView = ProfileView(
    imageSize: .large,
    direction: .column
  ).then {
    $0.delegate = self
  }
  
  private let roleContainerView = DescriptionContainerView(
    type: .custom("원하는 역할", CheckBoxContainerView(
      titles: [
        RoleType.developer.description,
        RoleType.designer.description,
        RoleType.planner.description,
        RoleType.marketer.description
      ])
    )
  )
  
  private let locationContainerView = DescriptionContainerView(
    type: .textField("활동지역", "활동지역을 검색해주세요.")
  )
  
  private var interestTitles: [String] = []
  private lazy var interestsContainerView = DescriptionContainerView(
    type: .custom("관심분야", RoundSelectionButtonView(titles: interestTitles)
    )
  )
  
  private let portfolioContainerView = DescriptionContainerView(
    type: .textField("포트폴리오", "포트폴리오 URL을 입력 해주세요. (선택)")
  )
  
  private let periodContainerView = DescriptionContainerView(
    type: .custom("경력기간", CheckBoxContainerView(
      titles: [
        Career.aspirant.description,
        Career.junior.description,
        Career.senior.description
      ],
      eventType: .radio)
    )
  )
  
  private var skillsViews: [CastableView] = []
  private lazy var skillContainerView = DescriptionContainerView(
    type: .custom(
      "보유 스킬",
      CastableContainerView(views: skillsViews)
    )
  )
  
  private lazy var saveButton = RoundRutton().then {
    $0.setTitle("저장", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    $0.backgroundColor = .lightGray
    $0.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
  }
  
  private let containerScrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
  }
  
  private let flexContainer = UIView()
  
  public weak var delegate: ProfileEditDelegate?
  
  public var disposeBag = DisposeBag()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboards)
    )
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func dismissKeyboards() {
    locationContainerView.textField.resignFirstResponder()
    portfolioContainerView.textField.resignFirstResponder()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    containerScrollView.pin
      .all()
      .layout()
    
    containerScrollView.contentSize = .init(
      width: view.bounds.size.width,
      height: view.bounds.size.height + 560
    )
    
    flexContainer.pin
      .width(of: view)
      .height(containerScrollView.contentSize.height)
      .top(UIApplication.keyWindow?.safeAreaInsets.top ?? 0)
      .left().right()
      .layout()
    
    flexContainer.flex.layout()
    
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  public func bind(reactor: Reactor) {
    
    Observable.just(())
      .map { Reactor.Action.viewDidLoad }
      .bind(to: reactor.action)
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
        self?.skillsViews = roleSkillsList.map {
          RoundSelectionButtonView(
            titles: $0.skills.map { $0.name },
            direction: .vertical
          )
        }
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.profile }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] profile in
        self?.updateViews(profile: profile)
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.imageURL }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] imageURL in
        Task {
          await self?.profileView.profileImageView.setImage(url: imageURL)
        }
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.route }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] in
        switch $0 {
        case .back:
          CommonAlert.shared.setMessage(
            .message("회원 정보가 수정되었습니다.")
          )
          .show()
          .confirmHandler = { [weak self] in
            self?.delegate?.routeToBack()
          }
        }
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.error }
      .observe(on: MainScheduler.instance)
      .bind { error in
        CommonAlert.shared.setMessage(.message(error.localizedDescription))
          .show()
          .confirmHandler = {
            print("comfirm")
          }
      }.disposed(by: disposeBag)
  }
}

private extension ProfileEditController {
  func configureUI() {
    view.backgroundColor = .white
    
    containerScrollView.addSubview(flexContainer)
    
    view.addSubview(containerScrollView)
    
    flexContainer.flex
      .marginHorizontal(20)
      .define { flex in
        flex.addItem(profileView)
          .alignSelf(.center)
        
        [roleContainerView,
         locationContainerView,
         interestsContainerView,
         portfolioContainerView,
         periodContainerView,
         skillContainerView
        ].forEach {
          flex.addItem($0)
            .marginBottom(18)
        }
        
        flex.addItem(saveButton)
          .height(50)
    }
  }
  
  @objc func didTapSaveButton() {
    
    let profileURL = ""
    
    let roles: [RoleType] = roleContainerView.customView?.casting(
      type: CheckBoxContainerView.self
    )
    .checkedItems?
    .compactMap { RoleType(description: $0.title) } ?? []
    
    let interestings: [String] = interestsContainerView.customView?.casting(
      type: RoundSelectionButtonView.self
    )
    .selectedItems ?? []
    
    let portfolioURL = portfolioContainerView.textField.text
    
    guard let carrer: String = Career(
      rawValue: reactor?.currentState.profile?.career?.rawValue ?? ""
    )?.rawValue else { return }
    
    let skills: [String] = skillContainerView.customView?.casting(
      type: CastableContainerView.self
    )
    .selectedItems
    .flatMap { $0 } ?? []
    
    let parameter: ProfileEditParameter = .init(
      profileURL: profileURL,
      roles: roles,
      region: reactor?.currentState.region,
      interestings: interestings,
      portfolioURL: portfolioURL,
      career: carrer,
      skills: skills
    )
    
    reactor?.action.onNext(.didTapSaveButton(parameter))
  }
}

private extension ProfileEditController {
  func updateViews(profile: Profile) {
    profileView.update(
      url: .init(string: profile.profileURL ?? ""),
      userName: profile.nickname,
      roles: profile.roles
    )
    
    if let role = roleContainerView.customView?.casting(
      type: CheckBoxContainerView.self
    ) {
      role.setSelectedItems(
        items: profile.roles.map { $0.description }
      )
    }
    
    let location = locationContainerView.textField
    location.text = profile.region?.description
    
    if let interests = interestsContainerView.customView?.casting(
      type: RoundSelectionButtonView.self
    ) {
      interests.setSelectedItems(items: profile.interestings.map { $0.description })
    }
    
    let portfolio = portfolioContainerView.textField
    portfolio.text = profile.portfolioURL
    
    if let period = periodContainerView.customView?.casting(
      type: CheckBoxContainerView.self
    ) {
      period.setSelectedItems(items: [profile.career?.description ?? ""])
    }
    
    if let skills = skillContainerView.customView?.casting(
      type: CastableContainerView.self
    ) {
      skills.setSelectedItems(items: profile.skills)
    }
  }
}

extension ProfileEditController: ProfileViewDelegate {
  func didTapEditProfileButton() {
    ImagePickerManager.shared.selectedImage { [weak reactor] image in
      reactor?.action.onNext(.requestUploadImage(image.pngData()))
    }
  }
}

extension ProfileEditController: UIGestureRecognizerDelegate {
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
