//
//  ComplexPolishOperator.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/26/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class ComplexPolishOperator: SimplePolishOperator  {
    private let _comparePriority: Int
    override var comparePriority: Int {
        return _comparePriority
    }
    
    init(_ representation: String, _ stackPriority: Int, _ comparePriority: Int, _ rpn: String? = nil) {
        _comparePriority = comparePriority
        super.init(representation, stackPriority, rpn)
    }
}
