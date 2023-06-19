//
//  SettingTests.swift
//  LeBaluchonTests
//
//  Created by Lilian Grasset on 19/06/2023.
//

import XCTest
@testable import LeBaluchon

final class SettingTests: XCTestCase {

    override func setUp() {
        UserDefaults.standard.removeObject(forKey: "DarkModeEnabled")
        SettingsHandler.shared.setUp()
    }
    
    // MARK: Testing SettingsHandler class
    func testSetUpUserDefaultsShouldContaintDarkModeEnabled() {
        
        let defaults = UserDefaults.standard
        let darkModeEnabled = defaults.bool(forKey: "DarkModeEnabled")
        
        XCTAssertTrue(darkModeEnabled)
    }
    
    func testSetDarkModeUserDefaultsShouldContaintDarkModeEnabledToFalse() {
        SettingsHandler.shared.setDarkMode(enabled: false)
        
        let defaults = UserDefaults.standard
        let darkModeEnabled = defaults.bool(forKey: "DarkModeEnabled")
        
        XCTAssertFalse(darkModeEnabled)
    }
    
    func testGetDarkModeUserDefaultsShouldContaintDarkModeEnabledToFalse() {
        SettingsHandler.shared.setDarkMode(enabled: false)
        
        let darkModeEnabled = SettingsHandler.shared.getIsDarkModeEnabled()
        
        XCTAssertFalse(darkModeEnabled)
    }
}
