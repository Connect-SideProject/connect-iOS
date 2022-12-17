//
//  MeetingCreateRepositoryImpl.swift
//  Meeting
//
//  Created by sean on 2022/12/10.
//

import Foundation

import CODomain
import CONetwork
import RxSwift

public class MeetingCreateRepositoryImpl: MeetingCreateRepository {
  
  private let apiService: ApiService
  
  public init(apiService: ApiService = ApiManager.shared) {
    self.apiService = apiService
  }
}

extension MeetingCreateRepositoryImpl {
  public func requestCreateMeeting(parameter: CreateMeetingParameter) -> Observable<String> {
    
    return apiService.request(endPoint: .init(path: .createMeeting(parameter)))
  }
}
