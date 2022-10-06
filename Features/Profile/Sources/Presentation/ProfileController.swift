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
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    return stackView
  }()

  private lazy var skillContainerView = DescriptionContainerView(
    type: .custom(
      "보유 스킬",
      CastableContainerView(
        views: [RoundSelectionButtonView(
          titles: reactor?.currentState.profile?.skills.map { $0 } ?? [""],
          isSelectable: false,
          direction: .vertical
        )],
        direction: .column)
    )
  )
  
  private let flexContainer = UIView()
  
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
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    bindEvent()
  }
  
  public func bind(reactor: Reactor) {
    Observable.just(())
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
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.profileSubItems }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] items in
        
        self?.appendProfileSubItemViews(items: items)
        
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
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    view.backgroundColor = .white
    
    view.addSubview(flexContainer)
    
    flexContainer.flex
      .define { flex in
        flex.addItem(profileView)
          .height(100)
        
        flex.addItem(buttonContainerView)
          .height(35)
          .marginVertical(10)
          .marginHorizontal(20)
        
        flex.addItem(stackView)
          .height(120)
          .marginVertical(10)
          .marginHorizontal(20)
        
        flex.addItem(skillContainerView)
          .marginHorizontal(20)
      }
  }
  
  private func bindEvent() {
    buttonContainerView.handler = { offset in
      print(offset)
    }
    
    skillContainerView.customView?
      .casting(type: CastableContainerView.self).handler = {
        print($0)
    }
  }
  
  private func appendProfileSubItemViews(items: [ProfileSubItem]) {
    
    let stackViews: [ProfileSubItemStackView] = items.map { .init(item: $0) }
    
    stackViews.forEach {
      self.stackView.addArrangedSubview($0)
    }
  }
}

extension ProfileController: ProfileViewDelegate {
  func didTapEditProfileButton() {
    print("didTapEditButton")
  }
}
