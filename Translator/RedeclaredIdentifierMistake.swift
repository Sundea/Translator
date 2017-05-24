//
//  RedeclaredIdentifierMistake.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/23/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

/// Repredents redeclared Identifer
class RedeclaredIdentifierMistake: Mistake {
    override var description: String {
        return "\(position)    \(token!)    Redeclared variable."
    }
}
