//
//  MeetingCreateRepository.swift
//  Meeting
//
//  Created by sean on 2022/12/10.
//

import Foundation

import CODomain
import RxSwift

public protocol MeetingCreateRepository {
  func requestCreateMeeting(parameter: CreateMeetingParameter) -> Observable<String>
}
