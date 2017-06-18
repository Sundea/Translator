//
//  WorkLabel.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/30/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class WorkLabel: Identifier {
    
    init() {
        super.init("r" + WorkLabel.nextIndex().description)
    }
    
    override var stringValue: String {
        return representation
    }
}



// MARK: - Static
extension WorkLabel {
    
    fileprivate static var count = 0
    
    
    /// Returns next index
    fileprivate static func nextIndex() -> Int {
        count += 1
        return count
    }
    
    
    /// Set index to zero
    /// Invoke this method every time, when start translating
    static func setIndexToZero() {
        count = 0
    }
}
