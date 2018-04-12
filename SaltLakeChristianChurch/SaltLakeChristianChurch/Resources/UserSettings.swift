//
//  UserSettings.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 4/12/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

struct UserSettings {
    
    // Bool to see if darkMode is enables
    static var darkModeEnabled: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "darkMode")
        }
        get {
            if UserDefaults.standard.object(forKey: "darkMode") == nil {
                UserDefaults.standard.set(false, forKey: "darkMode")
                return true
            }
            return UserDefaults.standard.bool(forKey: "darkMode")
        }
    }
    
}
