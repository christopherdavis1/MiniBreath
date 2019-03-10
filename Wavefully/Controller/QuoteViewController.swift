//
//  QuoteViewController.swift
//  Wavefully
//
//  Created by Christopher Davis on 3/9/19.
//  Copyright © 2019 Social Pilot. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import RealmSwift


class QuoteViewController: UIViewController {

    
    // MARK: - ACTIONS
    @IBAction func quoteButtonTapped(_ sender: UIButton) {}
    @IBAction func settingButtonTapped(_ sender: Any) {}
    
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var quoteContainerView: UIView!
    @IBOutlet weak var quoteImageContainerView: UIView!
    @IBOutlet weak var quoteImageView: UIImageView!
    @IBOutlet weak var quoteImageGradientCoverView: UIView!
    @IBOutlet weak var quoteStack: UIStackView!
    @IBOutlet weak var quoteText: UILabel!
    @IBOutlet weak var quoteAttribution: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var statsStackContainerView: UIStackView!
    @IBOutlet weak var totalSessionsContainerView: UIView!
    @IBOutlet weak var TotalSessionsBackgroundView: UIView!
    @IBOutlet weak var totalSessionsCountLabel: UILabel!
    @IBOutlet weak var totalSessionsDescriptionLabel: UILabel!
    @IBOutlet weak var totalSecondsContainerView: UIView!
    @IBOutlet weak var totalSecondsBackgroundView: UIView!
    @IBOutlet weak var totalSecondsCountLabel: UILabel!
    @IBOutlet weak var totalSecondsDescriptionLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    
    // MARK: - VARIABLES
    var quoteTextContent: String = ""
    var quoteAttributionContent: String = ""
    var databaseRef: DatabaseReference!
    var quotes: Results<QuoteObject>!
    var allQuotes = uiRealm.objects(QuoteObject.self)
    var unseenQuotes = uiRealm.objects(QuoteObject.self).filter("hasSeen = false")
    var numberOfMeditationsCount: Int = 0
    var secondsOfMeditationCount: Int = 0
    weak var delegate: ViewController!
    
    
    // MARK: - CONSTANTS
    let impact = UIImpactFeedbackGenerator()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect to Firebase
        databaseRef = Database.database().reference()
        grabData()
        print(allQuotes.count)
        
        randomQuote()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        totalSecondsCountLabel.text = String(secondsOfMeditationCount)
        totalSessionsCountLabel.text = String(numberOfMeditationsCount)
    }
    
    
    
    
    
    // MARK: — Functions: Database Stuff
    
    // Get data from Firebase
    func grabData() {
        
        databaseRef.child("quotes").observe(.value, with: {
            snapshot in
            
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                
                guard let dictionary = snap.value as? NSDictionary else {
                    return
                }
                
                let quote = dictionary["quoteText"] as? String
                let author = dictionary["quoteAttribution"] as? String
                let hasSeen = dictionary["hasSeen"] as? Bool
                let id = dictionary["quoteID"] as? String
                
                let quoteToAdd = QuoteObject()
                
                quoteToAdd.quoteText = quote
                quoteToAdd.quoteAttribution = author
                quoteToAdd.hasSeen = hasSeen!
                quoteToAdd.quoteID = id
                
                quoteToAdd.writeToRealm()
                
                self.reloadData()
            }
        })
    }
    
    
    func reloadData() {
        quotes = uiRealm.objects(QuoteObject.self)
    }
    
    // Grabs a random quote from Realm
    func randomQuote() {
        
        resetHasSeen()
        
        let singleQuote = allQuotes.randomElement()!
        let singleQuoteText = singleQuote.quoteText
        let singleQuoteAttribution = singleQuote.quoteAttribution
        let singleQuoteSeen = singleQuote.hasSeen
        let singleQuoteID = singleQuote.quoteID
        
        // If a quote has not been seen, display it.
        if singleQuoteSeen == false {
            quoteText.text = singleQuoteText
            quoteAttribution.text = singleQuoteAttribution
            
            try! uiRealm.write {
                singleQuote.hasSeen = true
                print(singleQuoteID as Any)
                print(singleQuoteText as Any)
                print(unseenQuotes.count)
                print("Wrote to Realm")
            }
        } else {
            // if it has been seen, skip it.
            print("Skipped quote")
            randomQuote()
        }
    }
    
    
    // If all quotes have been seen, reset all of them to unseen.
    func resetHasSeen() {
        let seenQuotesCount = unseenQuotes.count
        
        if seenQuotesCount == 0 {
            for quote in allQuotes {
                
                try! uiRealm.write {
                    quote.hasSeen = false
                }
            }
            print("Reset all quotes to unseen.")
        }
    }
    
    
// MARK: - CLOSING BRACKET!
}
