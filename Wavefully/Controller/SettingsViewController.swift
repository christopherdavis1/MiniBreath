//
//  SettingsViewController.swift
//  Wavefully
//
//  Created by Christopher Davis on 1/5/19.
//  Copyright © 2019 Social Pilot. All rights reserved.
//

import UIKit
import Instabug
import UserNotifications


class SettingsViewController: UITableViewController {
    

    // MARK: - Actions
    @IBAction func AllowNotificationsSwitchToggled(_ sender: UISwitch) {
        AllowNotificationsSwitchChanged()
    }
    
    @IBAction func SetCustomTimeSwitchToggled(_ sender: UISwitch) {
        setCustomTimeSwitchChanged()
    }
    @IBAction func morningQuoteSwitchToggled(_ sender: UISwitch) {
        setMorningQuotes()
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
    @IBOutlet weak var notificationsTimingLabel: UILabel!
    @IBOutlet weak var morningQuoteSwitch: UISwitch!
    
    
    
    
    // MARK: - Variables
    let center = UNUserNotificationCenter.current()
    var onOffLabelDefault = "Notifications are off."
    var hintTimingLabelDefault = "Tap to turn on."
    var notificationsAllowed = false
    var notificationsOn = false
    
    
    
    // MARK: - View Will Appear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the content doesn't fall offscreen, don't scroll
        tableView.alwaysBounceVertical = false
        
        // Watch for changes of the Switch states
        AllowNotificationsSwitch.addTarget(self, action: #selector(AllowNotificationsSwitchToggled(_:)), for: .valueChanged)
        
        SetCustomTimeSwitch.addTarget(self, action: #selector(SetCustomTimeSwitchToggled(_:)), for: .valueChanged)
        
        morningQuoteSwitch.addTarget(self, action: #selector(morningQuoteSwitchToggled(_:)), for: .valueChanged)
        
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
    
    
    // MARK: - Functions for handling notifications switches
    
    // Allow Notifications Switch
    func AllowNotificationsSwitchChanged() {
        if notificationsOn == false {
            // if the notifications haven't been allowed yet:
            registerNotifications()
            scheduleDefaultPushNotifications()
            AllowNotificationsSwitch.setOn(true, animated: true)
            notificationsAllowed = true
            print("Notifications are on and allowed")
            
            // If notifications are allowed and turned on already:
        } else if notificationsAllowed == true && notificationsOn == true {
            // If notifications are both allowed and ON when the switch is tapped...
            // Remove pending notification requests
            center.removeAllPendingNotificationRequests()
            // And turn the switch off...
            AllowNotificationsSwitch.setOn(false, animated: true)
            // And set the allowed to false:
            notificationsAllowed = false
            notificationsTimingLabel.text = "Notifications are turned off."
            
            // If notifications are allowed, but turned off:
        } else if notificationsOn == true && notificationsAllowed == false {
            // Reset the schedule
            scheduleDefaultPushNotifications()
            // Turn the switch back on:
            AllowNotificationsSwitch.setOn(true, animated: true)
            // And tell the app that notifications are allowed...
            notificationsAllowed = true
        }
    }
    
    
    
    // Allow Custom Time Switch
    func setCustomTimeSwitchChanged() {}
    
    
    // Get morning quotes
    func setMorningQuotes() {}
    
    
    
    // MARK: - Turning on / off push notifications & setting timing
    
    // Function for registering notifictions:
    @objc func registerNotifications() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            if granted {
                self.notificationsOn = true
                print("\("Notifications are") \(self.notificationsOn)")
                print("Granted")
            } else {
                print("\("Notifications are") \(self.notificationsOn)")
                print("Not Granted")
            }
        }
    }
    
    
    // Function for setting a custom push notification time:
    @objc func scheduleDefaultPushNotifications() {
        
        // What does the content say?
        let content = UNMutableNotificationContent()
        content.title = "Mindful Moment Reminder"
        content.body = "Take a 10 second pause, and reflect on something inspiring."
        content.categoryIdentifier = "reminder"
        content.sound = UNNotificationSound.default
        
        // The timing:
        
        // Un-Comment to show the notification every day at 2:00pm EST
        //        let dateComponents = DateComponents()
        //        dateComponents.hour = 14
        //        dateComponents.minute = 00
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        notificationsTimingLabel.text = "\("Notifications are set for") \(trigger.timeInterval) \("seconds from now.")"
        
        // Show the notification content at the time assigned!
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    
    
    // MARK: - Closing Bracket
}
