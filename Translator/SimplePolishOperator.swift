//
//  SimplePolishOperator.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/26/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class SimplePolishOperator: Terminal, ReversePolishOperator, ReversePolishElement {
    
    private(set) var stackPriority: Int
    
    var comparePriority: Int {
        return stackPriority
    }
    
    private(set) var rpn: String?
    
    var snapshot: String {
        return rpn ?? representation
    }
    
    init(_ representation: String, _ stackPriority: Int, _ rpn: String? = nil) {
        self.rpn = rpn
        self.stackPriority = stackPriority
        super.init(representation)
    }
    
    var stringValue: String {
        return rpn ?? representation
    }
}

