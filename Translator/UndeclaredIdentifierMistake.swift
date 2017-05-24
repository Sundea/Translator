//
//  UndeclaredIdentifierMistake.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

/// Repredents undecred Identifer
class UndeclaredIdentifierMistake: Mistake {
    
    override var description: String {
        return "\(position)    \(token!)    Undeclared variable."
    }
}
