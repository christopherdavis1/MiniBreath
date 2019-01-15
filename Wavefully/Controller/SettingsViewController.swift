//
//  SettingsViewController.swift
//  Wavefully
//
//  Created by Christopher Davis on 1/5/19.
//  Copyright © 2019 Social Pilot. All rights reserved.
//

import UIKit
import Instabug


class SettingsViewController: UITableViewController {
    

    // MARK: - Actions
    @IBAction func AllowNotificationsSwitchToggled(_ sender: UISwitch) {
        AllowNotificationsSwitchChanged()
    }
    
    @IBAction func SetCustomTimeSwitchToggled(_ sender: UISwitch) {
        setCustomTimeSwitchChanged()
    }
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var AllowNotificationsCell: UITableViewCell!
    @IBOutlet weak var CustomNotificationTimeCell: UITableViewCell!
    @IBOutlet weak var CustomNotficationSetCell: UITableViewCell!
    @IBOutlet weak var LeaveFeedbackCell: UITableViewCell!
    @IBOutlet weak var TweetAppCell: UITableViewCell!
    @IBOutlet weak var RateAppCell: UITableViewCell!
    @IBOutlet weak var FollowCreatorCell: UITableViewCell!
    @IBOutlet weak var ThanksCell: UITableViewCell!
    @IBOutlet weak var AllowNotificationsSwitch: UISwitch!
    @IBOutlet weak var SetCustomTimeSwitch: UISwitch!
    
    
    
    
    // MARK: - Variables
    
    
    
    
    // MARK: - View Will Appear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the content doesn't fall offscreen, don't scroll
        tableView.alwaysBounceVertical = false
        
        // Watch for changes of the Switch states
        AllowNotificationsSwitch.addTarget(self, action: #selector(AllowNotificationsSwitchToggled(_:)), for: .valueChanged)
        
        SetCustomTimeSwitch.addTarget(self, action: #selector(SetCustomTimeSwitchToggled(_:)), for: .valueChanged)
        
    }
    
    
    
    // MARK: - FUNCTIONS
    
    
    // Functions for acting on whatever row you tap.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            // Actions are in AllowNotificationsSwitch
        }
        else if indexPath.section == 0 && indexPath.row == 1 {
            // Actions are in SetCustomTimeSwitch
        }


        if indexPath.section == 1 && indexPath.row == 0 {
            BugReporting.invoke()
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            launchAppTwitter()
        }


        if indexPath.section == 2 && indexPath.row == 0 {
            print("You want to rate the app.")
        }


        if indexPath.section == 3 && indexPath.row == 0 {
            launchMyTwitter()
        }
        else if indexPath.section == 3 && indexPath.row == 1 {
            
            // Pushes to the Thanks and Acknowledgements Page
            performSegue(withIdentifier: "ThanksToThanksDetail", sender: nil)
        }

    }
    
    
    
    // Function for opening Twitter if possible
    // Open the Twitter app to my profile, or open to the web.
    func launchMyTwitter() {
        let screenName = "ObviousUnrest"
        let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = NSURL(string: "https://twitter.com/\(screenName)")!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
    
    // Open the Twitter app to my app's profile, or open to the web.
    func launchAppTwitter() {
        let screenName = "ObviousUnrest"
        let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = NSURL(string: "https://twitter.com/\(screenName)")!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
    
    
    // Mark: - Functions for handling notifications switches
    // Allow Notifications Switch
    func AllowNotificationsSwitchChanged() {
        if AllowNotificationsSwitch.isOn {
            print("Notifications are allowed.")
        } else {
            print("Notifications are not allowed.")
        }
    }
    
    // Allow Custom Time Switch
    func setCustomTimeSwitchChanged() {
        if SetCustomTimeSwitch.isOn {
            print("You set a new custom time.")
        } else {
            print("You are using the standard time.")
        }
    }
    
    
    // MARK: - Closing Bracket
}
