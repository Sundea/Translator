//
//  ReversePolishNotationParser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/27/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class ReversePolishNotationParser {
    
    lazy var magazine = Stack<SimplePolishOperator>()
    lazy var output = [ReversePolishNotation]()
    lazy var snapshots = [ExpressionParserSnapshot]()
    var input: Queue<Token>
    
    init(_ input: inout Queue<Token>) {
        self.input = input
    }
    
    func parse() {
        generateReversePolishNotation()
        evaluate()
    }
    
    func generateReversePolishNotation()  {

    }
    
    
    
    func evaluate() {

    }
    
    func makeSnapshot()  {
        let inputString = input.array.reduce("") { result, element in
            if element.lexeme != OperatorPool.newLine {
                return "\(result) \(element.lexeme.representation)"
            } else {
                return result
            }
        }
        let resultString = output.reduce("") { result, element in "\(result) \(element.snapshot)" }
        let stackString = magazine.array.reduce("") { result, op in "\(result) \(op.snapshot)" }
        let snapshot = ExpressionParserSnapshot(inputString, stackString, resultString)
        snapshots.append(snapshot)
    }
}

extension ReversePolishNotationParser {
    func subparser() -> ReversePolishNotationParser? {
        var result: ReversePolishNotationParser?
        if let front = input.front {
            switch front.lexeme {
                //            case OperatorPool.forKeyword:
            //                result =
            case _ as Identifier:
                let _ = input.dequeue()
                if let next = input.front, next.lexeme === OperatorPool.assignValue {
                        let newArray = [front] + input.array
                        input = Queue<Token>(newArray)
                        result = ExpressionParser(&self.input)
                } else {
                    let newArray = [front] + input.array
                    input = Queue<Token>(newArray)
                }
            case OperatorPool.write:
                result = WriteParser(&input)
            case OperatorPool.read:
                result = ReadParser(&input)
            default:
                break
            }
        }
        return result
    }
    
    func append(_ subsnapthots: [ExpressionParserSnapshot]) {
        if let last = snapshots.last {
            for snapshot in subsnapthots {
                let newSnap = ExpressionParserSnapshot(last.inputStream + " " + snapshot.inputStream,last.stack + " " + snapshot.stack, last.reversePolish + " " + snapshot.reversePolish)
                snapshots.append(newSnap)
            }
        } else {
            snapshots = subsnapthots
        }
    }
}
