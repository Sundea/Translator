//
//  RPNSnapshot.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

struct RPNSnaphot {
    let input: String
    let output: String
    let stack: String
    
    init(_ input: String, _ stack: String, _ output: String) {
        self.input = input
        self.stack = stack
        self.output = output
    }
}
