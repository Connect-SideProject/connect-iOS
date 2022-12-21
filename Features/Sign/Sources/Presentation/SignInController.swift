//
//  SignInController.swift
//  connect
//
//  Created by sean on 2022/08/24.
//

import UIKit

import CODomain
import COExtensions
import FlexLayout
import PinLayout
import ReactorKit
import Then
import KakaoSDKCommon
import COCommonUI
import COAuth

public protocol SignInDelegate: AnyObject {
  func routeToSignUp(authType: AuthType, accessToken: String)
  func routeToMain()
}

public final class SignInController: UIViewController, ReactorKit.View {
  
  private let backgroundImageView = UIImageView().then {
    $0.image = UIImage(named: "img_signIn")
  }
  
  private let signInLabel = UILabel().then {
    let attributedText = "IT를 연결하다\n커넥트잇".addAttributes(
      [
        .foregroundColor: UIColor.hex05A647
      ],
      range: .init(location: 9, length: 4)
    )
    $0.attributedText = attributedText
    $0.font = .bold(size: 24)
    $0.numberOfLines = 2
  }
  
  private let signInContainer = UIView()
  
  private let flexContainer = UIView()
  
  public weak var delegate: SignInDelegate?
  
  public var disposeBag: DisposeBag = .init()
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    flexContainer.pin
      .width(of: view)
      .height(of: view)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    
    KakaoSDK.initSDK(appKey: Auth.ThirdParty.kakaoSDK)
  }
  
  public func bind(reactor: SignInReactor) {
    reactor.state
      .map { $0.route }
      .filter { $0 != nil }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] route in
        switch route {
        case .home:
          self?.delegate?.routeToMain()
        case let .signUp(authType, accessToken):
          self?.delegate?.routeToSignUp(authType: authType, accessToken: accessToken)
        default:
          break
        }
      }.disposed(by: disposeBag)
    
    reactor.state
      .compactMap { $0.error }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] error in
        CommonAlert.shared
          .setMessage(.message(error.localizedDescription))
          .show(viewController: self)
      }.disposed(by: disposeBag)
  }
}

extension SignInController {
  private func configureUI() {
    
    view.backgroundColor = .white
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    view.addSubview(flexContainer)
    
    flexContainer.flex
      .direction(.column)
      .define { flex in
        flex.addItem(backgroundImageView)
          .grow(1)
    }
    
    backgroundImageView.flex
      .define { flex in
        flex.addItem()
          .grow(1)
        flex.addItem(signInContainer)
      }
    
    signInContainer.flex
      .height(255)
      .paddingHorizontal(40)
      .marginBottom(54 + CGFloat(UIApplication.keyWindow?.safeAreaInsets.bottom ?? 0))
      .define { flex in
        flex.addItem(signInLabel)
        flex.addItem()
          .height(23)
        let buttons = makeSignInButtons()
        buttons.forEach {
          flex.addItem($0)
            .height(45)
          flex.addItem()
            .height(16)
        }
      }
  }
  
  private func makeSignInButtons() -> [UIButton] {
    return AuthType.allCases.enumerated()
      .map { offset, type in
        let button = UIButton()
        button.setBackgroundImage(.init(named: "img_\(type.description.lowercased())_signIn"), for: .normal)
        button.tag = offset
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapSignInButton(sender:)), for: .touchUpInside)
        return button
    }
  }
  
  @objc private func didTapSignInButton(sender: UIButton) {
    guard let authType: AuthType = .init(rawValue: sender.tag) else { return }
    
    reactor?.action.onNext(.didTapSignInButton(type: authType))
  }
}
