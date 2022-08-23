//
//  ProfileUseCase.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import RxSwift

protocol ProfileUseCase {
  func getProfile() -> Observable<Profile>
  func updateProfile(_ profile: Profile) -> Observable<Profile>
}
