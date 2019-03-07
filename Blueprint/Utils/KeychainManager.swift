//
//  KeychainManager.swift
//  Blueprint
//
//  Created by Jay Lees on 26/02/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import Foundation

class KeychainManager {
    private enum Key: String {
        case authToken = "authToken"
        case refreshToken = "refreshToken"
    }
    
    class var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.authToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.authToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    class var refreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.refreshToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.refreshToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }    
}
