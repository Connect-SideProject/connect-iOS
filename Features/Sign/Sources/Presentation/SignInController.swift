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

public protocol SignInDelegate: AnyObject {
  func routeToSignUp(authType: AuthType, accessToken: String)
  func routeToHome()
}

public final class SignInController: UIViewController, ReactorKit.View {
  
  private let signInLabel = UILabel().then {
    $0.text = "로그인"
    $0.font = .systemFont(ofSize: 22, weight: .bold)
    $0.textColor = .black
  }
  
  private let descriptionLabel = UILabel().then {
    $0.text = "이용약관 및 개인정보 처리방침 동의합니다."
    $0.font = .systemFont(ofSize: 14, weight: .semibold)
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
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
    
    KakaoSDK.initSDK(appKey: "ee72a7c08c0e36ae98010b8d02f646cf")
  }
  
  public func bind(reactor: SignInReactor) {
    reactor.state
      .map { $0.route }
      .filter { $0 != nil }
      .bind { [weak self] route in
        switch route {
        case .home:
          self?.delegate?.routeToHome()
        case let .signUp(authType, accessToken):
          self?.delegate?.routeToSignUp(authType: authType, accessToken: accessToken)
        default:
          break
        }
        
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
      .height(280)
      .marginTop(200 + CGFloat(UIApplication.keyWindow?.safeAreaInsets.top ?? 0))
      .marginHorizontal(50)
      .justifyContent(.spaceBetween)
      .define { flex in
        
        flex.addItem()
        
        flex.addItem(signInLabel)
        
        let buttons = makeSignInButtons()
        buttons.forEach {
          flex.addItem($0)
            .height(60)
        }
        
        flex.addItem(descriptionLabel)
    }
  }
  
  private func makeSignInButtons() -> [UIButton] {
    
    let titleColors: [UIColor] = [.black, .black, .white]
    let backgroundColors: [UIColor] = [.yellow, .green, .black]
    
    return AuthType.allCases.enumerated()
      .filter { $0.offset < titleColors.count }
      .map { offset, type in
        let button = UIButton()
        button.setTitle("\(type.description)로 시작하기", for: .normal)
        button.setTitleColor(titleColors[offset], for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        button.backgroundColor = backgroundColors[offset]
        
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        button.tag = offset
        
        button.addTarget(self, action: #selector(didTapSignInButton(sender:)), for: .touchUpInside)
        
        return button
    }
  }
  
  @objc private func didTapSignInButton(sender: UIButton) {
    guard let authType: AuthType = .init(rawValue: sender.tag) else { return }
    
    reactor?.action.onNext(.didTapSignInButton(type: authType))
  }
}
