//
//  Mistake.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/22/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


/// Represent mistake on lexer level check
class Mistake: CustomStringConvertible, Equatable, Hashable {

    let position: TextPoint
    let explanation: String
    
    init(_ explanation: String, _ position: TextPoint) {
        self.explanation = explanation
        self.position = position
    }

    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "\(position)    \(explanation)"
    }
    
    
    // MARK: - Equtable
    
    static func ==(lhs: Mistake, rhs: Mistake) -> Bool {
        return lhs.description == rhs.description
    }
    
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return position.hashValue ^ explanation.hashValue
    }
}


// MARK: - Comparable
extension Mistake: Comparable {
    
    static func <(lhs: Mistake, rhs: Mistake) -> Bool {
        return lhs.position < rhs.position
    }
    
    static func <=(lhs: Mistake, rhs: Mistake) -> Bool {
        return lhs.position <= rhs.position
    }

    static func >=(lhs: Mistake, rhs: Mistake) -> Bool {
        return lhs.position >= rhs.position
    }

    static func >(lhs: Mistake, rhs: Mistake) -> Bool {
        return lhs.position > rhs.position
    }
}
