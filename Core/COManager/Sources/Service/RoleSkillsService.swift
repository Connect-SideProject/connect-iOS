//
//  RoleSkillsService.swift
//  COManager
//
//  Created by sean on 2022/09/29.
//

import Foundation

import CODomain

public protocol RoleSkillsService {
  var isExists: Bool { get }
  
  var roleSkillsList: [RoleSkills] { get }
  
  func update(_ roleSkillsList: [RoleSkills])
}
