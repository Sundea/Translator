//
//  Relation.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


/// Describes relation between two tokens in single order used by predictive parsing table
///
/// - lessThan: left token less than right
/// - moreThan: left token more than right
/// - equal: left token equal right
enum Relation: String, CustomStringConvertible {
    case lessThan = "<•"
    case moreThan = "•>"
    case equal = "≐"
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return self.rawValue
    }
}
