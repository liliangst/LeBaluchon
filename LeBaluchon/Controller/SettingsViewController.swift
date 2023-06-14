//
//  SettingsViewController.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 14/06/2023.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var darkModeSwitch: UISwitch! {
        didSet {
            let isOn = SettingsHandler.shared.getIsDarkModeEnabled()
            darkModeSwitch.setOn(isOn, animated: false)
        }
    }
    
    @IBAction func switchDarkLightMode(_ sender: UISwitch) {
        SettingsHandler.shared.setDarkMode(enabled: sender.isOn)
        view.window?.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
    }
}
