//
//  ViewController.swift
//  Wavefully
//
//  Created by Christopher Davis on 5/10/18.
//  Copyright © 2018 Social Pilot. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import RealmSwift



class ViewController: UIViewController {
    
    // MARK: - ACTIONS
    
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {}
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        resetCountdown()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        playButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        playButton.isHighlighted = true
        countdownStartSound()
        hideOnboarding()
        print("Initial press!")
        
        if isRunning != true {
            isRunning = true
        }
    }
    
    
    // The Long press!
    @IBAction func startButtonPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.minimumPressDuration = 0.5
        playButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        // Start the long press
        if gestureRecognizer.state == .began {
            if isRunning == true {
                
                // Functions
                runTimer()
                
                if baseTime >= 0 && baseTime < 10 {
                    UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                        self.settingsButton.layer.opacity = 0
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.namasteText.text = "Breathe"
                            self.namasteText.textColor = Colors.lightGreyText
                        })
                    })
                }
                
                
                // Animations
                // Ripple the waves
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.transfromShapeSmall()
                }, completion: nil)
                
                // Hide the timer label text
                UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                    self.timerLabel.transform = .identity
                    self.timerLabel.alpha = 1
                }, completion: nil)
             
                // Other actions:
                print("You're pressing the timer.")
                
            }
        }

        
        // When the user lifts a finger off of the long press...
        if gestureRecognizer.state == .ended {
            if isRunning == true {
                isRunning = false
                timer.invalidate()
                pulsateRipples()
                
                playButton.isHighlighted = false
                playButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                print("Your paused your timer.")
            }
        }
    }
    
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var quoteLabel: UILabel! {
        didSet {
            quoteLabel.text = defaultQuote
            quoteLabel.numberOfLines = 5
            quoteLabel.alpha = 0
        }
    }
    
    @IBOutlet weak var quoteAttributionLabel: UILabel! {
        didSet {
            quoteAttributionLabel.text = defaultAttributionText
            quoteAttributionLabel.numberOfLines = 1
            quoteAttributionLabel.alpha = 0
        }
    }
    
    
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            timerLabel.text = blankCountdown
        }
    }
    
    @IBOutlet weak var namasteText: UILabel! {
        didSet {
            namasteText.text = startingNamasteTextMessage
        }
    }
    
    
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var resetButtonContainer: UIView!
    @IBOutlet weak var resetIcon: UIImageView!
    @IBOutlet weak var onboardingWelcomeLabel: UILabel!
    @IBOutlet weak var onboardingLabel: UILabel!
    @IBOutlet weak var onboardingDownArrow: UIImageView!
    @IBOutlet weak var circleView4: UIView!
    @IBOutlet weak var circleView3: UIView!
    @IBOutlet weak var circleView2: UIView!
    @IBOutlet weak var circleView1: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    
    
    // MARK: - VARIABLES
    var defaultQuote = "Test"
    var defaultAttributionText = "Test"
    var quoteIsHidden = true
    var blankCountdown = "10"
    var countdownSuccessMessage = "Reset"
    var startingNamasteTextMessage = " "
    var timer = Timer()
    var seconds = 10
    var zero = "0"
    var baseTime = 0
    var isPaused = false
    var isRunning = false
    var isReset = false
    var countdownTimerChimed = false
    var audioPlayer: AVAudioPlayer?
    var databaseRef: DatabaseReference!
    var quotes: Results<QuoteObject>!
    var allQuotes = uiRealm.objects(QuoteObject.self)
    var unseenQuotes = uiRealm.objects(QuoteObject.self).filter("hasSeen = false")
    var numberOfPlayTaps = 0
    
    
    // MARK: - CONSTANTS
    let impact = UIImpactFeedbackGenerator()
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Set the rounded corners for the ripples
        circleView4.layer.cornerRadius = circleView4.frame.size.width / 2
        circleView3.layer.cornerRadius = circleView3.frame.size.width / 2
        circleView2.layer.cornerRadius = circleView2.frame.size.width / 2
        circleView1.layer.cornerRadius = circleView1.frame.size.width / 2
        resetButtonContainer.layer.cornerRadius = resetButtonContainer.frame.size.width / 2
        
        playButton.isHidden = false
        playButton.isHighlighted = false
        timerLabel.alpha = 0
        resetButtonContainer.alpha = 0
        onboardingLabel.alpha = 0
        onboardingWelcomeLabel.alpha = 0
        onboardingDownArrow.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
         backgroundGradientView.setGradientBackground(colorOne: Colors.darkBackground, colorTwo: Colors.lightBackground)
        
        quoteLabel.text = ""
        quoteAttributionLabel.text = ""
        
        pulsateRipples()
        resetAnimationStartPositions()
        showOnboarding()
        bounceOnboarding()
    
    }
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBaseColors()
        
        // Connect to Firebase
        databaseRef = Database.database().reference()
        grabData()
        print(allQuotes.count)
        
    }
    
    
    
    
    // MARK: - MISC FUNCTIONS
    
    
    // MARK: - Functions to set UI:
    // Set starting colors and opacities
    
    func setBaseColors() {
        circleView4.setRoundedGradientBackground(colorOne: Colors.baseRed, colorTwo: Colors.lightBackground)
        circleView4.layer.opacity = 0.06
        circleView3.setRoundedGradientBackground(colorOne: Colors.baseRed, colorTwo: Colors.lightBackground)
        circleView3.layer.opacity = 0.10
        circleView2.setRoundedGradientBackground(colorOne: Colors.baseRed, colorTwo: Colors.lightBackground)
        circleView2.layer.opacity = 0.25
        circleView1.setRoundedGradientBackground(colorOne: Colors.baseRed, colorTwo: Colors.lightBackground)
        circleView1.layer.opacity = 0.90
        namasteText.textColor = Colors.lightGreyText
        namasteText.layer.opacity = 1.0
    }
    
    
    // Hide settings button on during exercise and bring it back when it's done.
    
    func hideAndShowSettingsButton() {
        if baseTime >= 1 && baseTime <= 9 {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
                self.settingsButton.layer.opacity = 0
            }, completion: nil)
        } else if baseTime == 10 {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
                self.settingsButton.layer.opacity = 1
                self.settingsButton.tintColor = .white
            }, completion: nil)
        } else if baseTime == 0 {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
                self.settingsButton.layer.opacity = 0
            }, completion: nil)
        }
    }
    
    
    
    // Onboarding Functions
    
    func showOnboarding() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            self.onboardingWelcomeLabel.transform = .identity
            self.onboardingWelcomeLabel.alpha = 1
            
            self.onboardingLabel.transform = .identity
            self.onboardingLabel.alpha = 1
            
            self.onboardingDownArrow.transform = .identity
            self.onboardingDownArrow.alpha = 1
        }, completion: nil)
        print("Onboarding is visible again.")
    }
    
    func hideOnboarding() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            let onboardingWelcomeLabelTransform = CGAffineTransform.init(translationX: 0, y: 4)
            self.onboardingWelcomeLabel.transform = onboardingWelcomeLabelTransform
            self.onboardingWelcomeLabel.alpha = 0
            
            let onboardingLabelTransform = CGAffineTransform.init(translationX: 0, y: 6)
            self.onboardingLabel.transform = onboardingLabelTransform
            self.onboardingLabel.alpha = 0
            
            let onboardingArrowTransform = CGAffineTransform.init(translationX: 0, y: 8)
            self.onboardingDownArrow.transform = onboardingArrowTransform
            self.onboardingDownArrow.alpha = 0
        }, completion: nil)
    }
    
    func bounceOnboarding() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            let bounceOnboardingWelcomeLabel = CGAffineTransform.init(translationX: 0, y: -12)
            self.onboardingWelcomeLabel.transform = bounceOnboardingWelcomeLabel
            
            let bounceOnboardingLabel = CGAffineTransform.init(translationX: 0, y: -10)
            self.onboardingLabel.transform = bounceOnboardingLabel
            
            let bounceOnboardingDownArrow = CGAffineTransform.init(translationX: 0, y: -16)
            self.onboardingDownArrow.transform = bounceOnboardingDownArrow
        }, completion: nil)
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isRunning = true
        // Hide onboarding UI
        UIView.animate(withDuration: 0, delay: 0.5, options: [], animations: {
            self.onboardingWelcomeLabel.isHidden = true
            self.onboardingLabel.isHidden = true
            self.onboardingDownArrow.isHidden = true
        }, completion: nil)
        
        print("Your timer is running.")
    }
    
    @objc func updateTimer() {
        if seconds != 0 {
            seconds -= 1
            baseTime += 1
            print(baseTime)
            timerLabel.text = timeString(time: TimeInterval(seconds))
            transfromShapes()
        }
        else {
            countdownFinished()
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let seconds = Int(time) % 60
        return String(format: "%2i", seconds)
    }
    
    
    
    // MARK: - Functions for transforming and pulsing the circles
    // Grow the circles
    func transfromShapes() {
        let circles = [circleView4, circleView3, circleView2, circleView1]
        
        for circle in circles {
            
            // Let's start by setting constants for the variables that we'll be incrimenting by
            let incrimentXBy: CGFloat = 0.38
            let incrimentYBy: CGFloat = 0.38
            
            // Get the current scale of the X and Y axis
            let currentXScale = circle?.transform.a
            let currentYScale = circle?.transform.d
            
            // Pass the new scale
            let newXScale = currentXScale! + incrimentXBy
            let newYScale = currentYScale! + incrimentYBy
            
            // transform the width and height of the shape with these numbers
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                circle?.transform = CGAffineTransform(scaleX: newXScale, y: newYScale)
            }, completion: nil)

            rippleSound()
            
            if isRunning != true {
                pulsateRipples()
            }
        }
    }
    
    func transfromShapeSmall() {
        let circles = [circleView4, circleView3, circleView2, circleView1]
        
        for circle in circles {
            
            // Let's start by setting constants for the variables that we'll be incrimenting by
            let incrimentXBy: CGFloat = 0.16
            let incrimentYBy: CGFloat = 0.16
            
            // Get the current scale of the X and Y axis
            let currentXScale = circle?.transform.a
            let currentYScale = circle?.transform.d
            
            // Pass the new scale
            let newXScale = currentXScale! + incrimentXBy
            let newYScale = currentYScale! + incrimentYBy
            
            // transform the width and height of the shape with these numbers
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                circle?.transform = CGAffineTransform(scaleX: newXScale, y: newYScale)
            }, completion: nil)
            
            if isRunning != true {
                pulsateRipples()
            }
        }
    }
    
    
    // When the countdown is finished, finish the fill
    func finishFill() {
        let circles = [circleView4, circleView3, circleView2, circleView1]
        
        for circle in circles {
            // Get the heights of the two views
            let heightOfView = view.frame.height
            let currentCircleSize = circle!.frame.size.height
            
            // If we're about at the end of our time
            if currentCircleSize != heightOfView {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    circle!.transform = CGAffineTransform(scaleX: 25, y: 25)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseIn], animations: {
                        self.quoteLabel.alpha = 1
                    }, completion: nil)
                    self.showQuoteAttribution()
                    self.moveCompletedQuote()
                })
            }
        }
        
        namasteText.textColor = .white
        
    }
    
    
    // Pulsate the circles
    func pulsateRipples() {
        let circles = [circleView4, circleView3, circleView2, circleView1]
        
        let defaultRippleOptions = [0.05, 0.08, 0.06, 0.07]
        let randomRippleOption = defaultRippleOptions.randomElement()
        
        for circle in circles {
            // get the height of the shape in the moment
            let animateSizeBy = randomRippleOption
            
            let currentScaleX = circle?.transform.a
            let currentScaleY = circle?.transform.d
            let newScaleX = currentScaleX! + CGFloat(animateSizeBy!)
            let newScaleY = currentScaleY! + CGFloat(animateSizeBy!)
            
            UIView.animate(withDuration: 1.0, delay: 0.25, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
                circle?.transform = CGAffineTransform(scaleX: newScaleX, y: newScaleY)
            }, completion: nil)
        }
    }
    
    
    
    
    
    // MARK: - Functions for finishing and resetting the countdown.
    // The function that dictates what happens when the countdown ends
    func countdownFinished() {
        randomQuote()
        finishFill()
        isRunning = false
        isPaused = false
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseOut], animations: {
            
            let replayButtonTransformInto = CGAffineTransform.init(translationX: 0, y: -10)
            self.resetButtonContainer.transform = replayButtonTransformInto
            self.resetButtonContainer.alpha = 1
            self.playButton.alpha = 0
        }, completion: nil)
        
        if seconds < 1 && countdownTimerChimed == false {
            countdownFinishedSound()
            impact.impactOccurred()
            countdownTimerChimed = true
        }
        
        timer.invalidate()
        timerLabel.text = countdownSuccessMessage
        namasteText.text = "Reflect"
        quoteLabel.alpha = 1
        circleView1.layer.opacity = 1.0
        namasteText.textColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.72)
        
        UIView.animate(withDuration: 0.4, delay: 2, options: [.curveEaseInOut],animations: {
            self.settingsButton.tintColor = .white
            self.settingsButton.layer.opacity = 1
        })
        
        print("Your countdown has finished.")
    }
    
    // The function that resets everything back to normal
    func resetCountdown() {
        timerLabel.text = blankCountdown
        namasteText.text = " "
        resetAnimationStartPositions()
        resetQuoteOpacity()
        hideQuoteAttribution()
        isRunning = false
        isPaused = false
        isReset = true
        countdownTimerChimed = false
        seconds = 10
        baseTime = 0
        resetButtonSound()
        impact.impactOccurred()
        print("You reset your timer.")
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            self.circleView1.transform = CGAffineTransform.identity
            self.circleView2.transform = CGAffineTransform.identity
            self.circleView3.transform = CGAffineTransform.identity
            self.circleView4.transform = CGAffineTransform.identity
            self.setBaseColors()
            self.settingsButton.tintColor = .lightGray
        }, completion: { _ in
            if self.circleView1.frame.size.width <= 172 {
                self.pulsateRipples()
            }
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.5, animations: {
            self.namasteText.textColor = Colors.lightGreyText
        })
        
    }
    
    
    
    func resetQuoteOpacity() {
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [.curveEaseOut], animations: {
            let quoteLabelTransform = CGAffineTransform.init(translationX: 0, y: -30)
            self.quoteLabel.transform = quoteLabelTransform
            self.quoteLabel.alpha = 0
        }, completion: nil)
        print("Your quote text has been hidden.")
    }
    
    func showQuoteAttribution() {
        UIView.animate(withDuration: 0.8, delay: 0.5, options: [.curveEaseIn], animations: {
            self.quoteAttributionLabel.alpha = 1
        }, completion: nil)
    }
    
    func hideQuoteAttribution() {
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [.curveEaseOut], animations: {
            let quoteAttributionTransform = CGAffineTransform.init(translationX: 0, y: -26)
            self.quoteAttributionLabel.transform = quoteAttributionTransform
            self.quoteAttributionLabel.alpha = 0
        }, completion: nil)
    }
    
    func moveCompletedQuote() {
        UIView.animate(withDuration: 0.8, delay: 0.4, options: [.curveEaseInOut], animations: {
            let completedQuoteLabelTransform = CGAffineTransform.init(translationX: 0, y: 40)
            self.quoteLabel.transform = completedQuoteLabelTransform
            
            let completedAttributionLabelTransform = CGAffineTransform.init(translationX: 0, y: 50)
            self.quoteAttributionLabel.transform = completedAttributionLabelTransform
        }, completion: nil)
    }
    
    
    func resetAnimationStartPositions() {
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseOut], animations: {
            let timerLabelTransform = CGAffineTransform.init(translationX: 0, y: 30)
            self.timerLabel.transform = timerLabelTransform
            self.timerLabel.alpha = 0
            
            let replayButtonTransformAway = CGAffineTransform.init(translationX: 0, y: 10)
            self.resetButtonContainer.transform = replayButtonTransformAway
            self.resetButtonContainer.alpha = 0
            
            self.playButton.alpha = 1
        }, completion: nil)
    }

    
    // MARK: — Database Stuff
    
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
            quoteLabel.text = singleQuoteText
            quoteAttributionLabel.text = singleQuoteAttribution
            
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
    

    // MARK: — UI SOUNDS
    
    // Play a sound when the countdown begins
    func countdownStartSound() {
        do {
            if seconds > 9 {
                audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "playStartSound", ofType: "m4a")!))
                audioPlayer?.play()
            }
        }
        catch {
            print(error)
        }
    }
    
    func countdownFinishedSound() {
        do {
            if seconds < 1 {
                audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "countdownFinishedSound", ofType: "m4a")!))
                audioPlayer?.play()
            }
        }
        catch {
            print(error)
        }
    }
    
    func resetButtonSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "resetButtonSound", ofType: "m4a")!))
            audioPlayer?.play()
        }
        catch {
            print(error)
        }
    }
    
    func rippleSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "rippleSound", ofType: "m4a")!))
            audioPlayer?.play()
        }
        catch {
            print(error)
        }
    }
    
    
    

    // MARK: - Closing Bracket  👇 🤙
}

