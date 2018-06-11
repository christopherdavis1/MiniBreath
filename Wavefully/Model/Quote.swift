//
//  Quote.swift
//  Wavefully
//
//  Created by Christopher Davis on 6/10/18.
//  Copyright © 2018 Social Pilot. All rights reserved.
//

import Foundation


class Quote {
    var quoteText: String
    var quoteAttribution: String
    var hasSeen: Bool
    var hasSaved: Bool
    
    init(quoteText: String, quoteAttribution: String, hasSeen: Bool, hasSaved: Bool){
        self.quoteText = quoteText
        self.quoteAttribution = quoteAttribution
        self.hasSeen = hasSeen
        self.hasSaved = hasSaved
    }
    
    convenience init() {
        self.init(quoteText: "", quoteAttribution: "", hasSeen: false, hasSaved: false)
    }
}
