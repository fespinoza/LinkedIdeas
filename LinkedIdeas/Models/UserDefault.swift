//
//  UserDefault.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 02/10/2019.
//  Copyright © 2019 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault {
  let key: String
  let defaultValue: String?

  init(_ key: String, defaultValue: String?) {
    self.key = key
    self.defaultValue = defaultValue
  }

  var wrappedValue: String? {
    get {
      return UserDefaults.standard.object(forKey: key) as? String? ?? defaultValue
    }
    set {
      if let newValue = newValue {
        UserDefaults.standard.set(newValue, forKey: key)
      } else {
        UserDefaults.standard.removeObject(forKey: key)
      }
    }
  }
}
