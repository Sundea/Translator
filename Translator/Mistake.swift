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

    /// Incorrect token
    let token: String?
    let position: TextPoint
    
    init(_ position: TextPoint, _ token: String? = nil) {
        self.token = token
        self.position = position
    }

    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "\(position)    \(token ?? "")    Generic lexer error."
    }
    
    
    // MARK: - Equtable
    
    static func ==(lhs: Mistake, rhs: Mistake) -> Bool {
        return lhs.token == rhs.token
    }
    
    
    // MARK: - Hashable
    
    var hashValue: Int {
        var hash = position.hashValue
        if let token = token {
            hash = hash ^ token.hashValue
        }
        return hash
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
