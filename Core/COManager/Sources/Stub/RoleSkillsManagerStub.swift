//
//  RoleSkillsManagerStub.swift
//  COManager
//
//  Created by sean on 2022/09/29.
//

import Foundation

import CODomain

public final class RoleSkillsManagerStub: RoleSkillsService {
  public var isExists: Bool
  
  public var roleSkillsList: [CODomain.RoleSkills] {
    let list = [
      "개발자": ["React", "Unreal Engine", "Three.js", "Flask", "AI", "Blockchain", "Go", "AWS", "Docker", "Unity", "Svelte", "Vue.js", "Next.js", "Node.js", "Django", "Spring", "iOS", "Android", "React-Native", "Flutter", "Kubernetes"],
      "마케터": ["UA", "Facebook", "Premiere Pro", "AfterEffect", "Illustrator", "Photoshop", "Google Spreadsheet", "Excel", "Amplitude", "Firebase", "GA4", "Instagram"],
      "디자이너":  ["Figma", "Illustrator", "Photoshop", "Zeplin", "Principle", "Invision", "Protopie", "AdobeXD", "Sketch", "AfterEffect"],
      "기획자": ["Figma", "UA", "GA4", "Firebase", "Amplitude", "Excel", "Python", "SQL", "Appsflyr", "Google Spreadsheet"]
    ]
    
    return list.enumerated().map { offset, element in
      CODomain.RoleSkills(
        id: offset,
        roleCode: "",
        roleName: element.key,
        skills: element.value.map { Skill(id: 0, code: "", name: $0, isAddUser: "") }
      )
    }.sorted { lhs, rhs in
      lhs.roleName < rhs.roleName
    }
  }
  
  public init(isExists: Bool) {
    self.isExists = isExists
  }
  
  public func update(_ roleSkillsList: [CODomain.RoleSkills]) {
    
  }
}
