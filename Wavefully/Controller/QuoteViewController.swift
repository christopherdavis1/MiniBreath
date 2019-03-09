//
//  QuoteViewController.swift
//  Wavefully
//
//  Created by Christopher Davis on 3/9/19.
//  Copyright © 2019 Social Pilot. All rights reserved.
//

import UIKit

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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
