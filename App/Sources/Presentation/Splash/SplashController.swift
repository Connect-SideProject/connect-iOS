//
//  SplashController.swift
//  connect
//
//  Created by sean on 2022/08/24.
//

import UIKit

import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa
import Then

import COExtensions
import CONetwork

protocol SplashDelegate: AnyObject {
  func didFinishSplashLoading()
}

/// 스플래쉬.
final class SplashController: UIViewController, ReactorKit.View {
  
  lazy var indicatorView = UIActivityIndicatorView(style: .large).then {
    $0.color = .black
    $0.startAnimating()
  }
  
  private let flexContainer = UIView()
  
  weak var delegate: SplashDelegate?
  
  var disposeBag = DisposeBag()
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    flexContainer.pin
      .width(of: view)
      .height(of: view)
      .top()
      .left()
      .layout()
    
    flexContainer.flex.layout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  func bind(reactor: SplashReactor) {
    
    /// 스킬리스트 요청
    Observable.just(())
      .delay(.milliseconds(300), scheduler: MainScheduler.instance)
      .map { Reactor.Action.requestRolesAndSkills }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .debug()
      .map { $0.isFinishRequests }
      .filter { $0 }
      .observe(on: MainScheduler.instance)
      .bind { [weak self] _ in
        self?.delegate?.didFinishSplashLoading()
      }.disposed(by: disposeBag)
  }
}

extension SplashController {
  
  private func configureUI() {
    view.backgroundColor = .white
    
    view.addSubview(flexContainer)
    
    flexContainer.flex
      .alignItems(.center)
      .define { flex in
        flex.addItem(indicatorView)
          .marginTop(view.bounds.height / 2 - 17.5)
      }
  }
}
