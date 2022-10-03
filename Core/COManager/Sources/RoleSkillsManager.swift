//
//  RoleSkillsManager.swift
//  COManager
//
//  Created by sean on 2022/09/25.
//

import Foundation

import CODomain
import COExtensions

public final class RoleSkillsManager: RoleSkillsService {
  
  public static let shared: RoleSkillsManager = RoleSkillsManager()
  
  public var isExists: Bool {
    return UserDefaults.standard.isExists(forKey: .roleSkillsList)
  }
  
  public var roleSkillsList: [RoleSkills] {
    return UserDefaults.standard.object(type: [RoleSkills].self, forKey: .roleSkillsList) ?? []
  }
  
  private init() {}
  
  public func update(_ roleSkillsList: [RoleSkills]) {
    UserDefaults.standard.set(object: roleSkillsList, forKey: .roleSkillsList)
  }
}
