//
//  SignInController.swift
//  connect
//
//  Created by sean on 2022/08/24.
//

import UIKit

import FlexLayout
import PinLayout
import Then

enum SignInProviderType: Int {
  case kakao = 0, naver, apple, none
}

protocol SignInDelegate: AnyObject {
  func didTapSignInButton(type: SignInProviderType)
}

final class SignInController: UIViewController {
  
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
  
  weak var delegate: SignInDelegate?
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    flexContainer.pin
      .width(of: view)
      .height(of: view)
      .layout()
    
    flexContainer.flex.layout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
}

extension SignInController {
  private func configureUI() {
    
    view.backgroundColor = .white
    
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
    
    return ["Kakao로 시작하기", "Naver로 시작하기", "Apple로 시작하기"].enumerated().map { offset, title in
      let button = UIButton()
      button.setTitle(title, for: .normal)
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
    delegate?.didTapSignInButton(
      type: SignInProviderType(rawValue: sender.tag) ?? .none
    )
  }
}
