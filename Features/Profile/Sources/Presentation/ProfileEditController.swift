//
//  ProfileEditController.swift
//  Profile
//
//  Created by sean on 2022/10/07.
//

import UIKit

import ReactorKit
import Then

import COCommonUI
import CODomain
import COExtensions
import COManager

public final class ProfileEditController: UIViewController, ReactorKit.View {
  
  public typealias Reactor = ProfileEditReactor
  
  private lazy var profileView = ProfileView(imageSize: .large, direction: .column).then {
    $0.delegate = self
  }
  
  private let roleContainerView = DescriptionContainerView(
    type: .custom("원하는 역할", CheckBoxContainerView(
      titles: [Role.developer.description, Role.designer.description, Role.planner.description, Role.marketer.description]
      )
    )
  )
  
  private let locationContainerView = DescriptionContainerView(
    type: .textField("활동지역", "활동지역을 검색해주세요.")
  )
  
  private let interestsContainerView = DescriptionContainerView(
    type: .custom("관심분야", RoundSelectionButtonView(
      titles: [Interestring.finance.description,
               Interestring.fashion.description,
               Interestring.entertainment.description,
               Interestring.health.description]
      )
    )
  )
  
  private let portfolioContainerView = DescriptionContainerView(
    type: .textField("포트폴리오", "포트폴리오 URL을 입력 해주세요. (선택)")
  )
  
  private let periodContainerView = DescriptionContainerView(
    type: .custom("경력기간", CheckBoxContainerView(
        titles: [Career.aspirant.description, Career.junior.description, Career.senior.description],
        eventType: .radio
      )
    )
  )
  
  private lazy var skillContainerView = DescriptionContainerView(
    type: .custom(
      "보유 스킬",
      CastableContainerView(
        views: roleSkillsService.roleSkillsList
          .map { RoundSelectionButtonView(titles: $0.skills.map { $0.name }, direction: .vertical) },
        direction: .column)
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
  
  public var disposeBag = DisposeBag()
  
  let roleSkillsService: RoleSkillsService
  
  init(roleSkillsService: RoleSkillsService) {
    self.roleSkillsService = roleSkillsService
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
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
      .top(UIApplication.keyWindow?.safeAreaInsets.top ?? 0)
      .left().right()
      .layout()
    
    flexContainer.flex.layout()
  }
  
  public func bind(reactor: Reactor) {
    Observable.just(())
      .map { Reactor.Action.viewDidLoad }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.profile }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] profile in
        self?.updateViews(profile: profile)
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
    
  }
}

private extension ProfileEditController {
  func updateViews(profile: Profile) {
    profileView.update(
      url: .init(string: profile.profileURL ?? ""),
      userName: profile.nickname,
      roles: profile.roles
    )
    
    if let role = roleContainerView.customView?.casting(type: CheckBoxContainerView.self) {
      role.setSelectedItems(items: profile.roles.map { $0.description })
    }
    
    let location = locationContainerView.textField
    location.text = profile.region?.description
    
    if let interests = interestsContainerView.customView?.casting(type: RoundSelectionButtonView.self) {
      interests.setSelectedItems(items: profile.interestings.map { $0.description })
    }
    
    let portfolio = portfolioContainerView.textField
    portfolio.text = profile.portfolioURL
    
    if let period = periodContainerView.customView?.casting(type: CheckBoxContainerView.self) {
      period.setSelectedItems(items: [profile.career?.description ?? ""])
    }
    
    if let skills = skillContainerView.customView?.casting(type: CastableContainerView.self) {
      skills.setSelectedItems(items: profile.skills)
    }
  }
}

extension ProfileEditController: ProfileViewDelegate {
  func didTapEditProfileButton() {
    
    ImagePickerManager().selectedImage { [weak self] image in
      self?.profileView.profileImageView.setImage(image)
    }
  }
}
