//
//  InterestManager.swift
//  COManager
//
//  Created by sean on 2022/10/20.
//

import Foundation

import CODomain
import COExtensions

public final class InterestManager: InterestService {
  
  private enum ServerBaseURL {
    static let image: String = "https://s3.ap-northeast-2.amazonaws.com/connect-profile/menu/"
  }
  
  public static let shared: InterestManager = InterestManager()
  
  public var isExists: Bool {
    return UserDefaults.standard.isExists(forKey: .interestList)
  }
  
  public var interestList: [Interest] {
    return UserDefaults.standard.object(type: [Interest].self, forKey: .interestList) ?? []
  }
  
  private init() {}
  
  public func update(_ interestList: [Interest]) {
    let interestList = interestList.map {
      // 이미지 URL활용을 위해 '_' 제거 및 소문자 처리 진행 후 저장
      let imageURL = ServerBaseURL.image + $0.code.replacingOccurrences(of: "_", with: "").lowercased() + ".jpg"
      $0.updateImageURL(imageURL)
      return $0
    }
    
    UserDefaults.standard.set(object: interestList, forKey: .interestList)
  }
}
