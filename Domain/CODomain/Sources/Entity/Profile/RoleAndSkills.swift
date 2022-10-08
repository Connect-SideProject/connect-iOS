//
//  Skill.swift
//  CODomain
//
//  Created by sean on 2022/09/25.
//

import Foundation

public class Skill: NSObject, NSCoding, Codable, Identifiable {
  
  public var id: Int = 0
  public var code: String = ""
  public var name: String = ""
  public var isAddUser: String = ""
  
  public override init() {
    super.init()
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id =        try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
    self.code =      try container.decodeIfPresent(String.self, forKey: .code) ?? ""
    self.name =      try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    self.isAddUser = try container.decodeIfPresent(String.self, forKey: .isAddUser) ?? ""
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(id, forKey: .id)
    try container.encode(code, forKey: .code)
    try container.encode(name, forKey: .name)
    try container.encode(isAddUser, forKey: .isAddUser)
  }
  
  public required init?(coder: NSCoder) {
    self.id =        coder.decodeInteger(forKey: CodingKeys.id.rawValue)
    self.code =      coder.decodeObject(forKey: CodingKeys.code.rawValue) as? String ?? ""
    self.name =      coder.decodeObject(forKey: CodingKeys.name.rawValue) as? String ?? ""
    self.isAddUser = coder.decodeObject(forKey: CodingKeys.isAddUser.rawValue) as? String ?? ""
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(id, forKey: CodingKeys.id.rawValue)
    coder.encode(code, forKey: CodingKeys.code.rawValue)
    coder.encode(name, forKey: CodingKeys.name.rawValue)
    coder.encode(isAddUser, forKey: CodingKeys.isAddUser.rawValue)
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "code_id"
    case code = "code_cd"
    case name = "code_nm"
    case isAddUser = "add_user"
  }
}

public extension Skill {
  convenience init(id: Int = 0, code: String = "", name: String = "", isAddUser: String = "") {
    self.init()
    
    self.id = id
    self.code = code
    self.name = name
    self.isAddUser = isAddUser
  }
}

public class RoleSkills: NSObject, NSCoding, Codable, Identifiable {

  public var id: Int = -1
  public var roleCode: String = ""
  public var roleName: String = ""
  public var skills: [Skill] = []
  
  public override init() {
    super.init()
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.roleCode = try container.decodeIfPresent(String.self, forKey: .roleCode) ?? ""
    self.roleName = try container.decodeIfPresent(String.self, forKey: .roleName) ?? ""
    self.skills =   try container.decodeIfPresent([Skill].self, forKey: .skills) ?? []
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(roleCode, forKey: .roleCode)
    try container.encode(roleName, forKey: .roleName)
    try container.encode(skills, forKey: .skills)
  }
  
  public required init?(coder: NSCoder) {
    self.roleCode = coder.decodeObject(forKey: CodingKeys.roleCode.rawValue) as? String ?? ""
    self.roleName = coder.decodeObject(forKey: CodingKeys.roleName.rawValue) as? String ?? ""
    self.skills =   coder.decodeObject(forKey: CodingKeys.skills.rawValue) as? [Skill] ?? []
  }
  
  public func encode(with coder: NSCoder) {
    coder.encode(roleCode, forKey: CodingKeys.roleCode.rawValue)
    coder.encode(roleName, forKey: CodingKeys.roleName.rawValue)
    coder.encode(skills, forKey: CodingKeys.skills.rawValue)
  }
  
  enum CodingKeys: String, CodingKey {
    case roleCode = "code_cd"
    case roleName = "code_nm"
    case skills = "codes"
  }
}

public extension RoleSkills {
  convenience init(id: Int = -1, roleCode: String = "", roleName: String = "", skills: [Skill] = []) {
    self.init()
    
    self.id = id
    self.roleCode = roleCode
    self.roleName = roleName
    self.skills = skills
  }
}
