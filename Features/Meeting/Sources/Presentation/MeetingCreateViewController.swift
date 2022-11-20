//
//  MeetingCreateViewController.swift
//  Meeting
//
//  Created by sean on 2022/11/09.
//

import Foundation
import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa
import Then

import COCommon
import COCommonUI
import COExtensions

public final class MeetingCreateViewController: UIViewController, ReactorKit.View {
  
  enum Height {
    static let scrollView: CGFloat = 160 + (UIDevice.current.hasNotch ? 0 : 150)
  }
  
  private let typeContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "모임유형",
        castableView: CheckBoxContainerView(
          titles: ["사이드 프로젝트", "스터디"],
          eventType: .radio
        )
      )
    )
  )
  
  private let wayContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "진행방식",
        castableView: CheckBoxContainerView(
          titles: ["오프라인", "온라인", "미정"],
          eventType: .radio
        )
      )
    )
  )
  
  private lazy var interestContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "분야",
        castableView: CastableButton(type: .downwordArrow("분야선택"))
      )
    )
  )
  
  private lazy var peopleContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "모집인원",
        castableView: CastableButton(type: .downwordArrow("역할"))
      )
    )
  )
  
  private lazy var dateContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "프로젝트 기간",
        castableView: CastableButton(type: .downwordArrow("기간"))
      )
    )
  )
  
  private lazy var locationContainerView = DescriptionContainerView(
    type: .custom(
      .init(
        title: "모임위치",
        castableView: CastableButton(type: .downwordArrow("지역"))
      )
    )
  )
  
  private let titleContainerView = DescriptionContainerView(
    type: .textField(
      .init(
        title: "제목",
        placeholder: "ex 안드로이드 앱 개발자 구해요",
        noticeText: "최대 30자까지 입력가능해요"
      )
    )
  )
  
  private let contentContainerView = DescriptionContainerView(
    type: .textView(
      .init(
        title: "내용",
        placeholder: "ex 안녕하세요. 같이 안드로이드 앱 개발하실 개발자분을 구하고 있어요. 5월 런칭을 목표로하고 있습니다.",
        noticeText: "최대 1000자까지 입력가능해요"
      )
    )
  )
  
  private let commentContainerView = DescriptionContainerView(
    type: .textField(
      .init(
        title: "포부 한마디",
        placeholder: "ex 이번 여름동안 같이 열심히 해나가요!",
        noticeText: "최대 30자까지 입력가능해요"
      )
    )
  )
  
  private lazy var createButton = RoundRutton(
    cornerRadius: 5,
    borderColor: .hex028236
  ).then {
    $0.setTitle("만들기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .medium(size: 16)
    $0.backgroundColor = .hex028236
    $0.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
  }
  
  private let containerScrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
  }
  
  private let flexContainer = UIView()
  
  public var disposeBag = DisposeBag()
  
  deinit {
    removeNotifications()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    bindEvent()
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
      .top()
      .left().right()
      .layout()
    
    flexContainer.flex.layout()
    
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  public func bind(reactor: MeetingCreateReactor) {
    
    reactor.pulse(\.$route)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] in
        switch $0 {
        case let .bottomSheet(type):
          let bottomSheet = BottomSheetController(
            type: type
          )
          bottomSheet.modalPresentationStyle = .overFullScreen
          bottomSheet.confirmHandler = { [weak self, weak reactor] selectedIndex, text in
            reactor?.action.onNext(.didTapLocationButton)
              
            if let button = self?.interestContainerView.customView as? CastableButton {
              button.setTitle(text, for: .normal)
            }
            
            if let button = self?.locationContainerView.customView as? CastableButton {
              button.setTitle("서울 \(text)", for: .normal)
            }
          }
          self?.present(bottomSheet, animated: true)
        case .close:
          self?.dismiss(animated: true)
        }
      }.disposed(by: disposeBag)
  }
}

private extension MeetingCreateViewController {
  func configureUI() {
    view.backgroundColor = .white
    
    containerScrollView.addSubview(flexContainer)
    
    view.addSubview(containerScrollView)
    
    flexContainer.flex
      .paddingHorizontal(20)
      .define { flex in
        
        [typeContainerView,
         wayContainerView,
         interestContainerView,
         dateContainerView,
         locationContainerView,
         titleContainerView,
         contentContainerView,
         commentContainerView
        ].forEach {
          flex.addItem($0)
            .marginBottom(18)
        }
        
        flex.addItem(createButton)
          .height(41)
      }
  }
  
  func bindEvent() {
    if let interestButton = interestContainerView.customView as? CastableButton {
      interestButton.handler = { [weak reactor] in
        reactor?.action.onNext(.didTapInterestButton)
      }
    }
    
    if let dateButton = dateContainerView.customView as? CastableButton {
      dateButton.handler = { [weak reactor] in
        reactor?.action.onNext(.didTapDateButton)
      }
    }
    
    if let locationButton = locationContainerView.customView as? CastableButton {
      locationButton.handler = { [weak reactor] in
        reactor?.action.onNext(.didTapLocationButton)
      }
    }
    
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboards)
    )
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
    
    registerNotifications()
  }
  
  @objc func dismissKeyboards() {
    view.endEditing(true)
  }
  
  @objc func didTapCreateButton() {
    
  }
}

extension MeetingCreateViewController: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return true
  }
}

extension MeetingCreateViewController: KeyboardResponder {
  public var targetView: UIView {
    commentContainerView.textField
  }
}
