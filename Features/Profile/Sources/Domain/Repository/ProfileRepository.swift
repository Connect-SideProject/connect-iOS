//
//  ProfileRepository.swift
//  connect
//
//  Created by sean on 2022/07/23.
//  Copyright © 2022 sideproj. All rights reserved.
//

import Foundation

import RxSwift
import CODomain

public protocol ProfileRepository {
  func userProfile() -> Observable<Profile>
  func updateProfile(parameter: ProfileEditParameter) -> Observable<Profile>
}
