//
//  UserDefaultsManager.swift
//  App
//
//  Created by 이건준 on 2022/12/18.
//

import Foundation
import COExtensions

public struct UserDefaultsManager {
    @UserDefaultWrapper(key: .currentLocation, defaultValue: MapCoordinate(x: 30, y: 30))
    static var currentLocation
}

@propertyWrapper
fileprivate struct UserDefaultWrapper<T: Codable> {
    private let key: UserDefaultsKeys
    private let defaultValue: T

    init(key: UserDefaultsKeys, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(object: encoded, forKey: key)
            }
        }
    }
}
