//
//  SignInTests.swift
//  SignTests
//
//  Created by sean on 2022/09/05.
//

@testable import Sign

import XCTest

import COManager
import CONetwork

final class SignInReactorTests: XCTestCase {

  var apiManagerStub: ApiManaerStub!
  let userManagerStub = UserManagerStub()
  var reactor: SignInReactor!
  
  override func setUp() {
    super.setUp()
    self.apiManagerStub = ApiManaerStub(state: .response(200))
    
    let container = SignInDIContainer(
      apiService: apiManagerStub,
      userService: userManagerStub
    )
    
    reactor = container.makeReactor()
  }
  
  override func tearDown() {
    reactor = nil
    super.tearDown()
    
    userManagerStub.remove()
  }
  
  func testOccurURLErrorNeedSignUp() {
    // given
    apiManagerStub = .init(state: .response(204))
    let container = SignInDIContainer(
      apiService: apiManagerStub,
      userService: userManagerStub
    )
    
    reactor = container.makeReactor()
    
    // when
    reactor.action.onNext(.didTapSignInButton(type: .kakao))
    
    // then
    if let urlError = reactor.currentState.error?.asURLError {
      XCTAssertEqual(urlError.code, URLError.Code.needSignUp)
    }
    
    // when
    reactor.action.onNext(.didTapSignInButton(type: .naver))
    
    // then
    if let urlError = reactor.currentState.error?.asURLError {
      XCTAssertEqual(urlError.code, URLError.Code.needSignUp)
    }
    
    // when
    reactor.action.onNext(.didTapSignInButton(type: .apple))
    
    // then
    if let urlError = reactor.currentState.error?.asURLError {
      XCTAssertEqual(urlError.code, URLError.Code.needSignUp)
    }
  }
  
  func testUpdateAccessToken() {
    // given
    
    // when
    reactor?.action.onNext(.didTapSignInButton(type: .kakao))
    
    // then
    XCTAssertTrue(userManagerStub.accessToken != "")
  }
  
  func testUpdateAccessTokenWhenDidTapSignInWithNaver() {
    // given
    
    // when
    reactor?.action.onNext(.didTapSignInButton(type: .naver))
    
    // then
    XCTAssertTrue(userManagerStub.accessToken != "")
  }
  
  func testUpdateAccessTokenWhenDidTapSignInWithApple() {
    // given
    
    // when
    reactor?.action.onNext(.didTapSignInButton(type: .apple))
    
    // then
    XCTAssertTrue(userManagerStub.accessToken != "")
  }
}
