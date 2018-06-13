//
//  Arrays.swift
//  Wavefully
//
//  Created by Christopher Davis on 6/10/18.
//  Copyright © 2018 Social Pilot. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension Array where Element: Hashable {
    var occurrences: [Element:Int] {
        return reduce(into: [:]) { $0[$1, default: 0] += 1 }
    }
}
