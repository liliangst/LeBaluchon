//
//  SettingsHandler.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 14/06/2023.
//

import Foundation

class SettingsHandler {
    static let shared = SettingsHandler()
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    // Set up all default values
    func setUp() {
        defaults.register(defaults: ["DarkModeEnabled" : true])
    }
}

// MARK: Dark Mode Setting
extension SettingsHandler {
    func setDarkMode(enabled: Bool) {
        defaults.set(enabled, forKey: "DarkModeEnabled")
    }
    
    func getIsDarkModeEnabled() -> Bool {
        return defaults.bool(forKey: "DarkModeEnabled")
    }
    
}
