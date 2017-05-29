//
//  MarkKeeper.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/28/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class MarkKeeper: ComplexPolishOperator {
    lazy var marks = [Transition]()
    
    init(_ op: SimplePolishOperator, _ firstMark: Transition) {
        super.init(op.representation, op.stackPriority, op.comparePriority, op.rpn)
        marks.append(firstMark)
    }
    
    override var snapshot: String {
        var snap = super.snapshot
        
        if !marks.isEmpty {
            for mark in marks {
                snap += mark.description
            }
        }
        return snap
    }
}
