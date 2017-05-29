//
//  ReversePolishOperator.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/26/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

protocol ReversePolishNotation {
    var snapshot: String { get }
}

protocol ReversePolishOperator: ReversePolishNotation {
    
    var stackPriority: Int { get }
    var comparePriority: Int { get }
    var rpn: String? { get }
}

extension Constant: ReversePolishNotation {
    var snapshot: String {
        return representation
    }
}

extension Identifier: ReversePolishNotation {
    var snapshot: String {
        return representation
    }
}
