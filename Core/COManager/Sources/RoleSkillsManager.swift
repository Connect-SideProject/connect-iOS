//
//  RoleSkillsManager.swift
//  COManager
//
//  Created by sean on 2022/09/25.
//

import Foundation

import CODomain
import COExtensions

public protocol RoleSkillsService {
  var isExists: Bool { get }
  
  var roleAndSkillsList: [RoleAndSkills] { get }
  
  func update(_ roleAndSkillsList: [RoleAndSkills])
}

public final class RoleSkillsManager: RoleSkillsService {
  
  public static let shared: RoleSkillsManager = RoleSkillsManager()
  
  public var isExists: Bool {
    return UserDefaults.standard.isExists(forKey: .roleAndSkillsList)
  }
  
  public var roleAndSkillsList: [RoleAndSkills] {
    return UserDefaults.standard.object(type: [RoleAndSkills].self, forKey: .roleAndSkillsList) ?? []
  }
  
  private init() {}
  
  public func update(_ roleAndSkillsList: [RoleAndSkills]) {
    UserDefaults.standard.set(object: roleAndSkillsList, forKey: .roleAndSkillsList)
  }
}
