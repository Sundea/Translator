//
//  Jump.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

enum JumpType: String {
    case unconditional = "БП"
    case falseCondition = "УПЛ"
}


class Jump: ReversePolishElement {
    
    let type: JumpType
    let label: Label
    
    init(_ type: JumpType, _ label: Label) {
        self.type = type
        self.label = label
    }
    
    var representation: String {
        return label.description + type.rawValue
    }
}
