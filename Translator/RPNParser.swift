//
//  RPNParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/29/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class RPNParser {
    
    
    // MARK: - Stored properties
    
    /// Temporary storage of operators
    lazy var magazine = Stack<SimplePolishOperator>()
    
    /// Parser result
    lazy var output = [ReversePolishElement]()
    
    /// Text representation of each parser step
    lazy var snapshots = [RPNSnaphot]()
    
    /// Tokens to conver into Reverse Polish Notation
    var input: Queue<Token>
    
    
    // MARK: - Lifecycle
    
    init(_ input: inout Queue<Token>) {
        self.input = input
    }
    
    
    // MARK: - Public
    
    /// Parses input token queue to RPN output array
    ///
    /// - Returns: true if succed; otherwise - false
    func parse() -> Bool {
        snapshot()
        
        while let token = input.dequeue(), token.lexeme != lastLexeme {
            if appendAsValue(of: token) {
                snapshot()
            } else if var operation = token.lexeme as? SimplePolishOperator {
                operation = replace(operation, at: token.position)
                if magazine.isEmpty {
                    magazine.push(operation)
                } else if !customAction(operation) {
                    appendByPriority(operation)
                }
                snapshot()
            }
        }
        
        popAll(to: nil)
        snapshot()
        
        return true
    }
    

    
    /// Appends to output array, if it is constant or identifier
    ///
    /// - Parameter token: token to append
    /// - Returns: true if it is constant or identifier; otherwise - false
    func appendAsValue(of token: Token) -> Bool {
        if token.lexeme is ValueStorable, let rpnElement = token.lexeme as? ReversePolishElement {
            output.append(rpnElement)
            return true
        }
        return false
    }
    
    
    /// Pops all operations from magazine up to operation, without this operation.
    /// If operaion is `nil` pops all operations.
    ///
    /// - Parameter operation: bound operation
    func popAll(to operation: SimplePolishOperator?) {
        while let top = magazine.top, top != operation  {
            let _ = magazine.pop()
            output.append(top)
        }
    }
    
    
    /// Appends to output array using default priority compare rule
    ///
    /// - Parameter operation: next operation in the queue
    func appendByPriority(_ operation: SimplePolishOperator) {
        while let prevOperation = magazine.top {
            if prevOperation.stackPriority >= operation.comparePriority {
                let _ = magazine.pop()
                output.append(prevOperation)
            } else {
                magazine.push(operation)
                break
            }
        }
    }
    
    func snapshot() {
        let inputString = input.array.reduce("") { result, element in
            if element.lexeme != OperatorPool.newLine {
                return "\(result) \(element.lexeme.representation)"
            } else {
                return result
            }
        }
        let resultString = output.reduce("") { result, element in "\(result) \(element.stringValue)" }
        let stackString = magazine.array.reduce("") { result, op in "\(result) \(op.stringValue)" }
        let snapshot = RPNSnaphot.init(inputString, stackString, resultString)
        snapshots.append(snapshot)
    }
    
    
    /// Flag to stop the parsing cycle
    var lastLexeme: Lexeme {
        return OperatorPool.newLine
    }
    
    
    func replace(_ operation: SimplePolishOperator, at position: TextPoint) -> SimplePolishOperator {
        return operation
    }
    
    func customAction(_ operation: SimplePolishOperator) -> Bool {
        return false
    }
}
