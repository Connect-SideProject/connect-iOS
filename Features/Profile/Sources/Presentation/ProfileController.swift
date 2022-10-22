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
      "보유 스킬",
      CastableContainerView(
        views: [RoundSelectionButtonView(
          titles: [],
          isSelectable: false,
          direction: .vertical
        )],
        direction: .column
      )
    )
  )
  
  private let flexContainer = UIView()
  
  public weak var delegate: ProfileDelegate?
  
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
        
        if let containerView = self?.skillContainerView.customView as? CastableContainerView {
          let _ = containerView.views.map {
            if let selectedButtonView = $0 as? RoundSelectionButtonView {
              selectedButtonView.updateTitles(profile.skills)
            }
          }
        }
        
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.profileViewItems }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] items in
        self?.defineProfileListViews(items: items)
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
      .maxHeight(view.bounds.height / 1.5)
      .define { flex in
        flex.addItem(profileView)
          .height(100)
        
        flex.addItem(buttonContainerView)
          .height(35)
          .marginVertical(10)
          .marginHorizontal(20)
        
        flex.addItem(listContainerView)
          .justifyContent(.spaceBetween)
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
  
  private func defineProfileListViews(items: [ProfileViewItem]) {
    
    let views: [ProfileListView] = items.map { .init(item: $0) }
    
    listContainerView.flex.define { flex in
      views.forEach {
        flex.addItem($0)
      }
    }
  }
}

extension ProfileController: ProfileViewDelegate {
  func didTapEditProfileButton() {
    delegate?.routeToEditProfile()
  }
}
