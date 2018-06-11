//
//  ViewController.swift
//  Wavefully
//
//  Created by Christopher Davis on 5/10/18.
//  Copyright © 2018 Social Pilot. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    // MARK: - Sample Quotes
    
    var quotes:[Quote] = [
        
        Quote(
            quoteText: "The only way to make sense out of change is to plunge into it, move with it, and join the dance.",
            quoteAttribution: "Alan Watts",
            hasSeen: false,
            hasSaved: false),
        Quote(
            quoteText: "Luck is what happens when preparation meets opportunity.",
            quoteAttribution: "Seneca",
            hasSeen: false,
            hasSaved: false),
        Quote(
            quoteText: "As long as we wish to be happier, we are no longer happy. ",
            quoteAttribution: "Walter Landor",
            hasSeen: false,
            hasSaved: false),
        Quote(
            quoteText: "If we learn to open our hearts, anyone, including the people who drive us crazy, can be our teacher. ",
            quoteAttribution: "Pema Chödrön",
            hasSeen: false,
            hasSaved: false),
        Quote(
            quoteText: "Everything is created twice, first in the mind and then in reality.",
            quoteAttribution: "Robin Sharma",
            hasSeen: false,
            hasSaved: false)
    ]
    
    
    
    
    // MARK: - ACTIONS
    
    @IBAction func replayButtonTapped(_ sender: UIButton) {
        resetCountdown()
    }
    
    // The Long press!
    @IBAction func startButtonPressed(_ gestureRecognizer: UILongPressGestureRecognizer) {
       
        // Start the long press
        if gestureRecognizer.state == .began {
            if isRunning == true {
                runTimer()
                isPaused = false
                playButton.isHighlighted = true
                gestureRecognizer.minimumPressDuration = 0
            } else {
                serveQuote()
            }
        }
        
        // If your finger moves at all during the long press...
        if gestureRecognizer.state == .changed {
            if isRunning == false {
                runTimer()
                hideOnboarding()
                playButton.isHighlighted = true
                gestureRecognizer.minimumPressDuration = 0
                timerLabel.isHidden = false
                countdownStartSound()
                UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                    
                    self.timerLabel.transform = .identity
                    self.timerLabel.alpha = 1
                    
                }, completion: nil)
            }
        }
        
        // When the user lifts a finger off of the long press...
        if gestureRecognizer.state == .ended {
            if isPaused == false {
                isPaused = true
                timer.invalidate()
                print("Your paused your timer.")
                playButton.isHighlighted = false
            } else {
                runTimer()
                isPaused = false
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
    
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var onboardingLabel: UILabel!
    @IBOutlet weak var onboardingDownArrow: UIImageView!
    
    
    
    // MARK: - VARIABLES
    var quote: Quote = Quote()
    var defaultQuote = "Test"
    var defaultAttributionText = "Test"
    var quoteIsHidden = true
    var blankCountdown = "10"
    var countdownSuccessMessage = "Namaste"
    var timer = Timer()
    var seconds = 10
    var zero = "0"
    var baseTime = 0
    var isPaused = false
    var isRunning = false
    var audioPlayer: AVAudioPlayer?
    
    
    // MARK: - CONSTANTS
    let impact = UIImpactFeedbackGenerator()
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isHidden = false
        timerLabel.alpha = 0
        replayButton.alpha = 0
        onboardingLabel.alpha = 0
        onboardingDownArrow.alpha = 0
        showOnboarding()
        bounceOnboarding()
        
    }
    
    
    // MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
    
        resetAnimationStartPositions()
        
    }
    
    
    
    // MARK: - MISC FUNCTIONS
    
    
    // Onboarding Functions
    
    func showOnboarding() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
            let onboardingLabelTransform = CGAffineTransform.init(translationX: 0, y: 6)
            self.onboardingLabel.transform = onboardingLabelTransform
            self.onboardingLabel.alpha = 1
            
            let onboardingArrowTransform = CGAffineTransform.init(translationX: 0, y: 8)
            self.onboardingDownArrow.transform = onboardingArrowTransform
            self.onboardingDownArrow.alpha = 1
        }, completion: nil)
    }
    
    func hideOnboarding() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.onboardingLabel.alpha = 0
            self.onboardingDownArrow.alpha = 0
        }, completion: nil)
    }
    
    func bounceOnboarding() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
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
            increaseQuoteOpacity()
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
        else {
            countdownFinished()
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        
        // let hours = Int(time) / 3600
        // let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        // return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        return String(format: "%2i", seconds)
    }
    
    
    // The function that dictates what happens when the countdown ends
    func countdownFinished() {
        isRunning = false
        isPaused = false
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [.curveEaseOut], animations: {
            
            let replayButtonTransformInto = CGAffineTransform.init(translationX: 0, y: -10)
            self.replayButton.transform = replayButtonTransformInto
            self.replayButton.alpha = 1
            self.playButton.alpha = 0
        }, completion: nil)
        
        timer.invalidate()
        countdownFinishedSound()
        impact.impactOccurred()
        timerLabel.text = countdownSuccessMessage
        quoteLabel.alpha = 1
        moveCompletedQuote()
        
        print("Your countdown has finished.")
    }
    
    // The function that resets everything back to normal
    func resetCountdown() {
        timerLabel.text = blankCountdown
        resetAnimationStartPositions()
        resetQuoteOpacity()
        hideQuoteAttribution()
        isRunning = false
        isPaused = false
        seconds = 10
        baseTime = 0
        resetButtonSound()
        impact.impactOccurred()
        print("You reset your timer.")
    }
    
    // This function is for changing the opacity of the quote
    func increaseQuoteOpacity() {
        if baseTime == 0 {
            quoteLabel.alpha = 0
        } else if baseTime >= 10 {
            quoteLabel.alpha = 1
            showQuoteAttribution()
            print("Your quote has arrived!")
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
                self.quoteLabel.alpha += 0.1
            }, completion: nil)
            
        }
    }
    
    func resetQuoteOpacity() {
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [.curveEaseOut], animations: {
            let quoteLabelTransform = CGAffineTransform.init(translationX: 0, y: -30)
            self.quoteLabel.transform = quoteLabelTransform
            self.quoteLabel.alpha = 0
        }, completion: nil)
        print("Your quote has been hidden.")
    }
    
    func showQuoteAttribution() {
        UIView.animate(withDuration: 0.8, delay: 1.5, options: [.curveEaseIn], animations: {
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
            self.replayButton.transform = replayButtonTransformAway
            self.replayButton.alpha = 0
            
            // self.playButton.transform = .identity
            self.playButton.alpha = 1
        }, completion: nil)
        
    }
    
    
    
    // MARK: - GET A RANDOM QUOTE
    
    func serveQuote() {
        let randomQuote = quotes.randomItem()!
        
        if randomQuote.hasSeen == false {
            quoteLabel.text = randomQuote.quoteText
            quoteAttributionLabel.text = randomQuote.quoteAttribution
            randomQuote.hasSeen = true
            
            print(randomQuote.quoteText)
            print(randomQuote.quoteAttribution)
        } else {
            serveQuote()
            print("Skipped Quote")
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
    
    
    

    // MARK: - Closing Bracket  👇 🤙
}

