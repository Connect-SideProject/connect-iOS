//
//  ProfileController.swift
//  connect
//
//  Created by sean on 2022/06/02.
//  Copyright © 2022 sideproj. All rights reserved.
//
import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa
import COCommonUI
import CODomain
import COExtensions

public protocol ProfileDelegate: AnyObject {
  func routeToEditProfile()
  func routeToSingIn()
  func routeToMyPost(_ type: ProfilePostType)
}

/// MY 화면 컨트롤러.
public final class ProfileController: UIViewController, ReactorKit.View {
  
  public typealias Reactor = ProfileReactor
  
  private lazy var profileView: ProfileView = {
    let view = ProfileView(direction: .row)
    view.delegate = self
    return view
  }()
  
  private let buttonContainerView = MenuButtonContainerView(
    types: [.appliedGroup, .wroteGroup, .bookmarkedGroup]
  )
  
  private let listContainerView = UIView()
  
  private lazy var skillContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "보유 스킬",
        castableView: CastableContainerView(
          views: [RoundSelectionButtonView(
            titles: [],
            isSelectable: false,
            direction: .vertical
          )],
          direction: .column
        )
      )
    )
  )
  
  private lazy var logoutButton = RoundRutton(
    cornerRadius: 5,
    borderColor: .hexC6C6C6
  ).then {
    $0.setTitle("로그아웃", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .medium(size: 16)
    $0.backgroundColor = .hexC6C6C6
    $0.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
  }
  
  private lazy var signOutButton = RoundRutton(
    cornerRadius: 5,
    borderColor: .white
  ).then {
    $0.setTitle("회원탈퇴", for: .normal)
    $0.setTitleColor(.red, for: .normal)
    $0.titleLabel?.font = .regular(size: 14)
    $0.backgroundColor = .white
    $0.addTarget(self, action: #selector(didTapSignOutButton), for: .touchUpInside)
  }
  
  private let flexContainer = UIView()
  
  public weak var delegate: ProfileDelegate?
  
  private let skillsButtonRelay = PublishRelay<RoundSelectionButtonUpdateType>()
  
  public var disposeBag: DisposeBag = .init()
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    flexContainer.pin
      .width(of: view)
      .height(of: view)
      .top(UIApplication.keyWindow?.safeAreaInsets.top ?? 0)
      .left()
      .layout()
    
    flexContainer.flex.layout()
    
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    bindEvent()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tabBarController?.tabBar.isHidden = false
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  public func bind(reactor: Reactor) {
    rx.viewWillAppear
      .map { _ in Reactor.Action.requestProfile }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.profile }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] profile in
        
        self?.profileView.update(
          url: .init(string: profile.profileURL ?? ""),
          userName: profile.nickname,
          roles: profile.roles
        )
        
        self?.skillsButtonRelay.accept(.titles(profile.skills))
        
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.profileViewItems }
      .observe(on: MainScheduler.instance)
      .take(2)
      .bind { [weak self] items in
        self?.defineProfileListViews(items: items)
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.profileViewItems }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] items in
        self?.updateProfileListViews(items: items)
      }.disposed(by: disposeBag)
    
    reactor.pulse(\.$route)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] route in
        switch route {
        case .routeToSignIn:
          self?.delegate?.routeToSingIn()
        }
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.message }
      .observe(on: MainScheduler.instance)
      .bind { messageType in
        CommonAlert.shared.setMessage(messageType)
          .show()
          .confirmHandler = {
            print("comfirm")
          }
      }.disposed(by: disposeBag)
  }
}

extension ProfileController {
  
  private func configureUI() {
    view.backgroundColor = .white
    
    view.addSubview(flexContainer)
    
    flexContainer.flex
      .justifyContent(.spaceBetween)
      .define { flex in
        flex.addItem(profileView)
          .height(100)
        
        flex.addItem()
          .height(10)
        
        flex.addItem(buttonContainerView)
          .height(35)
          .marginHorizontal(20)
        
        flex.addItem()
          .height(10)
        
        flex.addItem(listContainerView)
          .justifyContent(.spaceBetween)
          .height(120)
          .marginHorizontal(20)
          .markDirty()
        
        flex.addItem()
          .height(10)
        
        flex.addItem(skillContainerView)
          .marginHorizontal(20)
          .markDirty()
        
        flex.addItem(logoutButton)
          .margin(20)
          .height(40)
        
        flex.addItem()
          .direction(.row)
          .define { flex in
            flex.addItem()
              .grow(1)
            flex.addItem(signOutButton)
              .margin(20)
              .shrink(1)
          }
        
        flex.addItem()
          .grow(1)
      }
  }
  
  private func bindEvent() {
    buttonContainerView.handler = { offset in
        switch offset {
        case 1:
            self.delegate?.routeToMyPost(.study)
        case 2:
            self.delegate?.routeToMyPost(.bookMark)
        default:
            break
        }
    }
    
    skillsButtonRelay
      .bind(to: skillContainerView.updateRoundSelectionButtonRelay)
      .disposed(by: disposeBag)
  }
  
  private func defineProfileListViews(items: [ProfileViewItem]) {
    
    let views: [ProfileListView] = items.map { .init(item: $0) }
    
    listContainerView.flex.define { flex in
      views.forEach {
        flex.addItem($0)
      }
    }
  }
  
  private func updateProfileListViews(items: [ProfileViewItem]) {
    
    zip(listContainerView.subviews, items).forEach { view, item in
      if let view = view as? ProfileListView {
        view.update(item: item)
      }
    }
  }
  
  @objc private func didTapLogoutButton() {
    reactor?.action.onNext(.requestLogout)
  }
  
  @objc private func didTapSignOutButton() {
    reactor?.action.onNext(.requestSignOut)
  }
}

extension ProfileController: ProfileViewDelegate {
  func didTapEditProfileButton() {
    tabBarController?.tabBar.isHidden = true
    delegate?.routeToEditProfile()
  }
}
