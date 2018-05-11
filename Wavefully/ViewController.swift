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
            }
        }
        
        // If your finger moves at all during the long press...
        if gestureRecognizer.state == .changed {
            if isRunning == false {
                runTimer()
                playButton.isHighlighted = true
                gestureRecognizer.minimumPressDuration = 0
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
    
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            timerLabel.text = blankCountdown
        }
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    
    
    
    // MARK: - VARIABLES
    var defaultQuote = "The only way to make sense out of change is to plunge into it, move with it, and join the dance."
    var quoteIsHidden = true
    var blankCountdown = "00:00:10"
    var countdownSuccessMessage = "Namaste"
    var timer = Timer()
    var seconds = 10
    var zero = "0"
    var baseTime = 0
    var isPaused = false
    var isRunning = false
    
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replayButton.isHidden = true
        playButton.isHidden = false
    }
    
    
    
    // MARK: - MISC FUNCTIONS
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isRunning = true
        print("Your timer is running.")
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            countdownFinished()
        } else {
            seconds -= 1
            baseTime += 1
            print(baseTime)
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    // The function that dictates what happens when the countdown ends
    func countdownFinished() {
        isRunning = false
        isPaused = false
        replayButton.isHidden = false
        playButton.isHidden = true
        playButton.isHighlighted = false
        timer.invalidate()
        print("Your countdown has finished.")
    }
    
    // The function that resets everything back to normal
    func resetCountdown() {
        timerLabel.text = blankCountdown
        isRunning = false
        isPaused = false
        replayButton.isHidden = true
        playButton.isHidden = false
        playButton.isHighlighted = false
        seconds = 10
        baseTime = 0
        print("You reset your timer.")
    }
    


    // MARK: - Closing Bracket  👇 🤙
}

