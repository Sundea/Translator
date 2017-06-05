//
//  ParserSnapshot.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

struct ParserSnapshot: CustomStringConvertible {
    
    /// Text representation of the stack
    let stackDescription: String
    
    /// Text representation of the relation
    let relation: String
    
    /// Text representation of the input stream
    let inputStreamDescription: String
    
    let rpn: String
    
    init(_ stackDescription: String, _ relation: String, _ inputStreamDescription: String, _ rpn: String) {
        self.stackDescription = stackDescription
        self.relation = relation
        self.inputStreamDescription = inputStreamDescription
        self.rpn = rpn
    }
    
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "\(stackDescription) \(relation) \(inputStreamDescription) \(rpn)"
    }
}
