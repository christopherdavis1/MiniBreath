//
//  QuoteObject.swift
//  Wavefully
//
//  Created by Christopher Davis on 8/5/18.
//  Copyright © 2018 Social Pilot. All rights reserved.
//

import Foundation
import RealmSwift

class QuoteObject: Object {
    @objc dynamic var quoteText: String? = nil
    @objc dynamic var quoteAttribution: String? = nil
    @objc dynamic var quoteID: String? = "Test"
    @objc dynamic var hasSeen: Bool = false
    
    override static func primaryKey() -> String? {
        return "quoteID"
    }
}

extension QuoteObject {
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: .all)
        }
    }
}
