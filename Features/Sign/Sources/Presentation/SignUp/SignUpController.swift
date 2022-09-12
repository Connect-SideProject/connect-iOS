//
//  SignUpController.swift
//  Sign
//
//  Created by sean on 2022/09/06.
//

import UIKit

import COCommonUI
import COExtensions

public final class SignUpController: UIViewController {
  
  private let nicknameContainerView = DescriptionContainerView(
    type: .textField("닉네임", "닉네임을 입력하세요.")
  )
  
  private let locationContainerView = DescriptionContainerView(
    type: .textField("활동지역", "활동지역을 검색해주세요.")
  )
  
  private let periodContainerView = DescriptionContainerView(
    type: .custom("경력기간", CheckBoxContainerView(titles: ["지망생", "주니어", "시니어"]))
  )
  
  private let interestsContainerView = DescriptionContainerView(
    type: .custom("관심분야", SelectionButtonView(titles: ["금융", "패션/뷰티", "엔터테인먼트", "헬스케어"]))
  )
  
  private let jobContainerView = DescriptionContainerView(
    type: .custom("원하는 역할", SelectionButtonView(titles: ["기획자", "개발자", "디자이너", "마케터"]))
  )
  
  private let upper14YearsOldCheckBoxView = CheckBoxSingleView(
    title: "만 14세 이상임을 확인합니다."
  )
  
  private let acceptAllCheckBoxView = CheckBoxSingleView(
    title: "모든 필수 이용약관에 동의합니다."
  )
  
  private let checkBoxContainerView = CheckBoxContainerView(
    titles: [" 커넥트잇 이용약관(필수)  >", " 개인정보처리방침(필수)  >", " 위치기반서비스 이용약관(필수)  >"],
    direction: .vertical
  ).then {
    $0.backgroundColor = .lightGray
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
  }
  
  private let startButton = RoundRutton().then {
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
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    flexContainer.pin
      .width(of: view)
      .height(of: view)
      .top(CGFloat(UIApplication.keyWindow?.safeAreaInsets.top ?? 0))
      .left().right()
      .layout()
    
    flexContainer.flex.layout()
    
    containerScrollView.pin
      .all()
      .layout()
    
    containerScrollView.contentSize = flexContainer.frame.size
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
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
         jobContainerView].forEach {
          flex.addItem($0)
            .marginBottom(20)
        }
        
        [upper14YearsOldCheckBoxView,
         acceptAllCheckBoxView].forEach {
          flex.addItem($0)
            .marginTop(8)
            .height(26)
        }
        
        flex.addItem(checkBoxContainerView)
          .marginVertical(20)
          .marginLeft(10)
          .marginBottom(40)
          .height(110)
        
        flex.addItem(startButton)
          .marginHorizontal(20)
          .height(50)
    }
  }
  
  @objc func didTapStartButton() {
    if let job = jobContainerView.customView as? SelectionButtonView {
      print(job.selectedItems)
    }
    
    if let checkbox = periodContainerView.customView as? CheckBoxContainerView {
      print(checkbox.checkedItem)
    }
    
    if let interests = interestsContainerView.customView as? SelectionButtonView {
      print(interests.selectedItems)
    }
    
    print(upper14YearsOldCheckBoxView.isChecked)
    print(acceptAllCheckBoxView.isChecked)
  }
}
