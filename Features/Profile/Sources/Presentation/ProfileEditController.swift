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
  
  enum Height {
    static let scrollView: CGFloat = 610 + (UIDevice.current.hasNotch ? 0 : 150)
  }
  
  public typealias Reactor = ProfileEditReactor
  
  private lazy var profileView = ProfileView(
    imageSize: .large,
    direction: .column
  ).then {
    $0.delegate = self
  }
  
  private var roleTitles: [String] = []
  private lazy var roleContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "원하는 역할",
        castableView: RoundSelectionButtonView(
          titles: roleTitles
        )
      )
    )
  )
  
  private lazy var addressContainerView = DescriptionContainerView(
    type: .customWithAttributed(
      .init(
        attributedTitle: "활동지역 *".setLastWord(color: .red),
        castableView: CastableButton(type: .downwordArrow("활동 지역을 선택해주세요."))
      )
    )
  )
  
  private var interestTitles: [String] = []
  private lazy var interestsContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "관심분야",
        castableView: RoundSelectionButtonView(
          titles: interestTitles
        )
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
  
  private let periodContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "경력기간",
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
  
  private var skillsViews: [CastableView] = []
  private lazy var skillContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "보유 스킬",
        castableView: CastableContainerView(views: skillsViews)
      )
    )
  )
  
  private lazy var saveButton = RoundRutton(
    cornerRadius: 5,
    borderColor: .hex028236
  ).then {
    $0.setTitle("저장", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .medium(size: 16)
    $0.backgroundColor = .hex028236
    $0.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
  }
  
  private let containerScrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
  }
  
  private let flexContainer = UIView()
  
  public weak var delegate: ProfileEditDelegate?
  
  private let addressButtonRelay = PublishRelay<String>()
  private let roleItemsRelay = PublishRelay<RoundSelectionButtonUpdateType>()
  private let interestItemsRelay = PublishRelay<RoundSelectionButtonUpdateType>()
  private let periodItemsRelay = PublishRelay<RoundSelectionButtonUpdateType>()
  private let skillsItemsRelay = PublishRelay<RoundSelectionButtonUpdateType>()
  
  public var disposeBag = DisposeBag()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    bindEvent()
  }
  
  @objc func dismissKeyboards() {
    portfolioContainerView.textField.resignFirstResponder()
  }
  
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
        self?.roleTitles = roleSkillsList.map { $0.roleName }
        self?.skillsViews = roleSkillsList.map {
          RoundSelectionButtonView(
            titles: $0.skills.map { $0.name },
            direction: .vertical
          )
        }
      }.disposed(by: disposeBag)
    
    reactor.pulse(\.$profile)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] profile in
        self?.updateViews(profile: profile)
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.imageURL }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] imageURL in
        guard let `self` = self else { return }
        Task {
          await self.profileView.profileImageView.setImage(url: imageURL)
        }
      }.disposed(by: disposeBag)
    
    reactor.pulse(\.$route)
      .compactMap { $0 }
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
          
        case let .bottomSheet(items):
          BottomSheet(type: .address(items))
            .show()
            .handler = { [weak self, weak reactor] state in
              switch state {
              case let .confirm(selectedIndex, title):
                reactor?.action.onNext(.didSelectedLocation(selectedIndex))
                self?.addressButtonRelay.accept(title)
              default:
                break
              }
            }
        }
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.error }
      .observe(on: MainScheduler.instance)
      .bind { error in
        switch error {
        case let .message(_, message):
          CommonAlert.shared.setMessage(.message(message))
            .show()
        default:
          break
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
        
        flex.addItem(roleContainerView)
          .marginBottom(18)
        
        flex.addItem(addressContainerView)
          .marginBottom(18)
          .markDirty()
        
        [interestsContainerView,
         portfolioContainerView,
         periodContainerView,
         skillContainerView
        ].forEach {
          flex.addItem($0)
            .marginBottom(18)
        }
        
        flex.addItem(saveButton)
          .height(41)
      }
  }
  
  func bindEvent() {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboards)
    )
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
    
    addressButtonRelay
      .bind(to: addressContainerView.castableButtonRelay)
      .disposed(by: disposeBag)
    
    roleItemsRelay
      .debug()
      .bind(to: roleContainerView.updateRoundSelectionButtonRelay)
      .disposed(by: disposeBag)
    
    interestItemsRelay
      .bind(to: interestsContainerView.updateRoundSelectionButtonRelay)
      .disposed(by: disposeBag)
    
    skillsItemsRelay
      .bind(to: skillContainerView.updateRoundSelectionButtonRelay)
      .disposed(by: disposeBag)
    
    addressContainerView.buttonHandlerRelay
      .bind { [weak reactor] in
        reactor?.action.onNext(.didTapAddressButton)
      }.disposed(by: disposeBag)
  }
  
  func updateViews(profile: Profile) {
    profileView.update(
      url: .init(string: profile.profileURL ?? ""),
      userName: profile.nickname,
      roles: profile.roles
    )
    
    let roleItems = profile.roles.map { $0.description }
    roleItemsRelay.accept(.selectedItems(roleItems))
    
    let address = profile.region?.description ?? ""
    addressButtonRelay.accept(address)
    
    let interestItems = profile.interestings.map { $0.description }
    interestItemsRelay.accept(.selectedItems(interestItems))
    
    let portfolio = portfolioContainerView.textField
    portfolio.text = profile.portfolioURL
    
    let periodItems = [profile.career?.description ?? ""]
    periodItemsRelay.accept(.selectedItems(periodItems))
    
    let skillsItems = profile.skills
    skillsItemsRelay.accept(.selectedItems(skillsItems))
  }
  
  @objc func didTapSaveButton() {
    
    let profileURL = ""
    
    let roles: [RoleType] = roleContainerView.customView?.casting(
      type: RoundSelectionButtonView.self
    ).selectedItems.compactMap { RoleType(description: $0) } ?? []
    
    let interestings: [String] = interestsContainerView.customView?.casting(
      type: RoundSelectionButtonView.self
    ).selectedItems ?? []
    
    let portfolioURL = portfolioContainerView.textField.text
    
    let period = periodContainerView.customView?.casting(
      type: CheckBoxContainerView.self
    ).checkedItems?.compactMap { $0 } ?? []
    
    let carrer: Career? = .init(
      description: period[safe: 0]?.title ?? ""
    )
    
    let skills: [String] = skillContainerView.customView?.casting(
      type: CastableContainerView.self
    ).selectedItems.flatMap { $0 } ?? []
    
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

extension ProfileEditController: ProfileViewDelegate {
  func didTapEditProfileButton() {
    ImagePickerManager.shared.selectedImage { [weak self] image in
      self?.profileView.profileImageView.setImage(image)
      self?.reactor?.action.onNext(.requestUploadImage(image.pngData()))
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
