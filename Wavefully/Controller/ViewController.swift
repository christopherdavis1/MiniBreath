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

            if isRunning != true {
                isRunning = true
            }
            
            
            if isRunning == true {
                runTimer()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.headerTextLabel.layer.opacity = 1
                    self.subheaderTextLabel.layer.opacity = 0.5
                    self.countdownStackView.layer.opacity = 1
                }
                
                
                if breathPhaseTime >= 0 && breathPhaseTime < 20 {
                    UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                        self.settingsButton.layer.opacity = 0
                    }, completion: nil)
                }

                // Ripple the waves
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.transfromShapeSmall()
                }, completion: nil)
                
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

    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var resetButtonContainer: UIView!
    @IBOutlet weak var onboardingWelcomeLabel: UILabel!
    @IBOutlet weak var onboardingLabel: UILabel!
    @IBOutlet weak var onboardingDownArrow: UIImageView!
    @IBOutlet weak var circleView4: UIView!
    @IBOutlet weak var circleView3: UIView!
    @IBOutlet weak var circleView2: UIView!
    @IBOutlet weak var circleView1: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var subheaderTextLabel: UILabel!
    @IBOutlet weak var countdownStackView: UIStackView!
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step3View: UIView!
    @IBOutlet weak var step4View: UIView!
    
    
    
    
    // MARK: - VARIABLES
    var countdownSuccessMessage = "Reset"
    var timer = Timer()
    var seconds = 10
    var zero = "0"
    var baseTime = 0
    var isPaused = false
    var isRunning = false
    var isReset = false
    var countdownTimerChimed = false
    var audioPlayer: AVAudioPlayer?
    var numberOfSessions = 0
    var numberOfSeconds = 0
    
    var breathPhaseTime: Int = 0
    var totalCycleTime = 0
    var countOfSeconds = 20
    
    // MARK: - CONSTANTS
    let impact = UIImpactFeedbackGenerator()
    let defaults: UserDefaults = UserDefaults.standard
    
    
    // MARK: - VIEW LOADING & HIDING
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Set the rounded corners for the ripples
        circleView4.layer.cornerRadius = circleView4.frame.size.width / 2
        circleView3.layer.cornerRadius = circleView3.frame.size.width / 2
        circleView2.layer.cornerRadius = circleView2.frame.size.width / 2
        circleView1.layer.cornerRadius = circleView1.frame.size.width / 2
        backgroundGradientView?.setGradientBackground(colorOne: Colors.darkBackground, colorTwo: Colors.lightBackground)
        
        step1View.layer.cornerRadius = step1View.frame.height/2
        step2View.layer.cornerRadius = step2View.frame.height/2
        step3View.layer.cornerRadius = step3View.frame.height/2
        step4View.layer.cornerRadius = step4View.frame.height/2
        
        playButton.isHidden = false
        playButton.isHighlighted = false
        
        headerTextLabel.layer.opacity = 0
        subheaderTextLabel.layer.opacity = 0
        countdownStackView.layer.opacity = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        resetCountdown()
        showOnboarding()
        bounceOnboarding()
        pulsateRipples()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBaseColors()
        backgroundGradientView?.setGradientBackground(colorOne: Colors.darkBackground, colorTwo: Colors.lightBackground)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on all other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    
    // MARK: - FUNCTIONS
    
    
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
    
    
    
    
    
    // Timer Functions
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
        if countOfSeconds != 0 {
            
            breathPhaseTime += 1
            totalCycleTime += 1
            countOfSeconds -= 1
            
            seconds -= 1
            baseTime += 1
            
            if breathPhaseTime == 5 {
                breathPhaseTime = 0
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.step1View.frame.size.width = self.step1View.frame.size.width - 78
                    self.step4View.layer.opacity = 1
                    self.step4View.layer.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8862745098, blue: 0.8901960784, alpha: 1)
                    self.step3View.layer.opacity = 1
                    self.step3View.layer.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8862745098, blue: 0.8901960784, alpha: 1)
                    self.step2View.layer.opacity = 1
                    self.step2View.layer.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8862745098, blue: 0.8901960784, alpha: 1)
                    self.step1View.layer.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8862745098, blue: 0.8901960784, alpha: 1)
                }, completion: nil)
            }
            
            if breathPhaseTime == 1 {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.step1View.layer.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0, blue: 0, alpha: 1)
                }, completion: nil)
            } else if breathPhaseTime == 2 {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.step1View.frame.size.width = self.step1View.frame.size.width + 26
                    self.step2View.layer.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0, blue: 0, alpha: 1)
                    self.step2View.layer.opacity = 0
                }, completion: nil)
            } else if breathPhaseTime == 3 {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.step1View.frame.size.width = self.step1View.frame.size.width + 26
                    //self.step3View.layer.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.0862745098, blue: 0.0862745098, alpha: 1)
                    self.step3View.layer.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0, blue: 0, alpha: 1)
                    self.step3View.layer.opacity = 0
                }, completion: nil)
            } else if breathPhaseTime == 4 {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.step1View.frame.size.width = self.step1View.frame.size.width + 26
                    self.step4View.layer.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0, blue: 0, alpha: 1)
                    self.step4View.layer.opacity = 0
                }, completion: nil)
            }
            
            
            if totalCycleTime > 0 && totalCycleTime <= 4 {
                userIsInhaling()
            }
            
            else if totalCycleTime > 4 && totalCycleTime <= 9 {
                userIsHoldingBreath()
            }
            
            else if totalCycleTime > 9 && totalCycleTime <= 14 {
                userIsExhaling()
            }
            
            else if totalCycleTime > 14 && totalCycleTime <= 19 {
                userIsHoldingBreath()
            }
            
            print(baseTime)
        }
        else {
            countdownFinished()
        }
    }
    
    
    func timeString(time:TimeInterval) -> String {
        let seconds = Int(time) % 60
        return String(format: "%2i", seconds)
    }
    
    
    // Breathing Functions
    
    func userIsInhaling() {
        headerTextLabel.text = "Inhale"
        subheaderTextLabel.text = "Deeply through the nose"
        transfromShapes()
        if breathPhaseTime >= 1 && breathPhaseTime <= 4 {rippleSound()}
        if totalCycleTime == 4 {impact.impactOccurred()}
    }
    
    func userIsHoldingBreath() {
        headerTextLabel.text = "Pause"
        subheaderTextLabel.text = "Hold that breath"
        pulsateRipples()
        if breathPhaseTime >= 1 && breathPhaseTime <= 4 {rippleSound()}
        if totalCycleTime == 9 {impact.impactOccurred()}
    }
    
    func userIsExhaling() {
        headerTextLabel.text = "Exhale"
        subheaderTextLabel.text = "Fully, through the mouth"
        transfromShapes()
        if breathPhaseTime >= 1 && breathPhaseTime <= 4 {rippleSound()}
        if totalCycleTime == 14 {impact.impactOccurred()}
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

            //rippleSound()
            
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
                    self.headerTextLabel.layer.opacity = 0
                    self.subheaderTextLabel.layer.opacity = 0
                    self.countdownStackView.layer.opacity = 0
                    
                    circle!.transform = CGAffineTransform(scaleX: 25, y: 25)
                }, completion: nil)
            }
        }
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
            
            UIView.animate(withDuration: 0.75, delay: 0.25, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
                circle?.transform = CGAffineTransform(scaleX: newScaleX, y: newScaleY)
            }, completion: nil)
        }
    }
    
    
    
    
    
    // MARK: - Functions for finishing and resetting the countdown.
    // The function that dictates what happens when the countdown ends
    func countdownFinished() {
        finishFill()
        timer.invalidate()
        impact.impactOccurred()
        countdownFinishedSound()
        isRunning = false
        isPaused = false
        
        incrimentStats()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.performSegue(withIdentifier: "pushToQuoteView", sender: Any?.self)
        }

        print("Your countdown has finished.")
    }
    
    
    func incrimentStats() {
        
        numberOfSeconds = numberOfSeconds + 10
        defaults.set(numberOfSeconds, forKey: "numberOfSecondsCount")
        print(defaults.integer(forKey: "numberOfSecondsCount"))

        numberOfSessions = numberOfSessions + 1
        defaults.set(numberOfSessions, forKey: "numberOfSessionsCount")
        print(defaults.integer(forKey: "numberOfSessionsCount"))
    }
    
    
    // The function that resets everything back to normal
    func resetCountdown() {
        isRunning = false
        isPaused = false
        isReset = true
        countdownTimerChimed = false
        seconds = 10
        baseTime = 0
        
        breathPhaseTime = 0
        totalCycleTime = 0
        countOfSeconds = 20
        
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
    }
    
    
// MARK: - THE ANIMATIONS I USED FOR THE QUOTE
//    func showQuoteAttribution() {
//        UIView.animate(withDuration: 0.8, delay: 0.5, options: [.curveEaseIn], animations: {
//            self.quoteAttributionLabel.alpha = 1
//        }, completion: nil)
//    }
    
    
    
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
    
    
    // MARK: - Segues!
    
    // Step sessions & second count on countdown completion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pushToQuoteView" {
            let destinationVC = segue.destination as! QuoteViewController
            
            let currentNumberOfSeconds = defaults.integer(forKey: "numberOfSecondsCount")
            let currentNumberOfSessions = defaults.integer(forKey: "numberOfSessionsCount")
            
            destinationVC.secondsOfMeditationCount = currentNumberOfSeconds
            destinationVC.numberOfMeditationsCount = currentNumberOfSessions
        }
    }
    

// MARK: - Closing Bracket  👇 🤙
}

