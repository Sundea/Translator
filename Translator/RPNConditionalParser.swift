//
//  RPNConditionalParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RPNConditionpalParser: RPNParser {
    
    var label1: Label!
    var label2: Label!
    
    var type: JumpType = .falseCondition
    
    override init(_ input: inout Queue<Token>) {
        super.init(&input)
        self.lastLexeme = OperatorPool.endif
    }
    
    
    override func customAppend(_ operation: SimplePolishOperator) -> Bool {
        if operation === OperatorPool.elseKeyword {
            popAll(to: OperatorPool.ifKeyword)
            return true
        }
        return false
    }
    
    override func nestedParserWillWork() {
        popAll(to: OperatorPool.ifKeyword)
        
        if let pop = magazine.pop() {
            var keeper: RPNLabelKeeper
            
            switch pop {
            case let k as RPNLabelKeeper:
                keeper = k
            default:
                keeper = RPNLabelKeeper(pop.representation, pop.stackPriority, pop.comparePriority)
            }
            let jump = Jump(type, Label())
            output.append(jump)
            
            keeper.labels.append(jump.label)
            magazine.push(keeper)
            
            if type == .unconditional {
                labels[0].rpnIndex = output.count + 2
                output.append(labels.first!)
                type = .falseCondition
            } else {
                type = .unconditional
            }
            labels.append(jump.label)
            snapshot()
        }
    }
    
    override func magazineWillBecomeEmpty() {
        output.append(labels[1])
        labels[1].rpnIndex = output.count
        magazine = Stack<SimplePolishOperator>()
    }
}

