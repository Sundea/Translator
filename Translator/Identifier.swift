//
//  Identifier.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/26/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Identifier: Lexeme, ValueAccesible, ReversePolishElement {
    
    // MARK: - ValueAccesible
    
    var value: Int!
    
    func set(_ newValue: Int) {
        value = newValue
    }
    
    var stringValue: String {
        return self.representation
    }
}
