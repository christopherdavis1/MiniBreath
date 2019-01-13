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
        
    }
    
    
    
    // MARK: - FUNCTIONS
    
    
    // Functions for acting on whatever row you tap.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            print("You want to allow notifications.")
            
            if AllowNotificationsSwitch.isOn {
                print("Notifications are not allowed")
                AllowNotificationsSwitch.setOn(false, animated: true)
            } else {
                print("Notifications are allowed")
                AllowNotificationsSwitch.setOn(true, animated: true)
            }
            
        }
        else if indexPath.section == 0 && indexPath.row == 1 {
            print("You want to set a custom time.")
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
            print("Opened")
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
    
    
    
    
    // MARK: - Closing Bracket
}
