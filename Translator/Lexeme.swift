//
//  Lexeme.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Lexeme: Equatable, Hashable, CustomStringConvertible {
    let representation: String

    init(_ representation: String) {
        self.representation = representation
    }
    
    var hashValue: Int {
        return representation.hashValue
    }
    
    static func ==(lhs: Lexeme, rhs: Lexeme) -> Bool {
        return lhs.representation == rhs.representation
    }
    
    var description: String {
        return representation
    }
}


