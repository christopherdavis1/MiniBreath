//
//  SettingsViewController.swift
//  Wavefully
//
//  Created by Christopher Davis on 1/5/19.
//  Copyright © 2019 Social Pilot. All rights reserved.
//

import UIKit
import Instabug


class SettingsViewController: UIViewController {

    // MARK: - Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {}
    @IBAction func placeholderSettingsButtonTapped(_ sender: UIButton) {
        BugReporting.invoke()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsHeaderLabel: UILabel!
    @IBOutlet weak var settingsBackgroundSheet: UIView!
    @IBOutlet weak var placeholderContentStackView: UIStackView!
    @IBOutlet weak var placeholderSettingsLabel: UILabel!
    @IBOutlet weak var placeholderSettingsButton: UIButton!
    
    
    
    // MARK: - Variables
    
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        settingsBackgroundSheet.layer.opacity = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showSettingsPage()
    }
    
    // MARK: - View Will Appear
    override func viewDidLoad() {
        super.viewDidLoad()

        // write something here
        
    }
    
    
    // MARK: - FUNCTIONS
    
    func showSettingsPage() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            let settingsPageTransform = CGAffineTransform.init(translationX: 0, y: 8)
            self.settingsBackgroundSheet.transform = settingsPageTransform
            self.settingsBackgroundSheet.layer.opacity = 1
        }, completion: nil)
    }
    
}
