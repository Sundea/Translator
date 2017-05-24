//
//  Parser.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/22/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Parser {
    
    let parsingTable: ParsingTable
    
    private lazy var stack: Stack<ParsingTableToken> = {
        var stack = Stack<ParsingTableToken>()
        stack.push(self.parsingTable.startEndToken)
        return stack
    }()
    
    
    private var inputStream: Queue<ParsingTableToken>!
    
    /// Logs
    lazy var snapshots = [ParserSnapshot]()
    
    /// Contains mistakes if there is, otherwise - empty array
    lazy var mistakes = [Mistake]()
    
    var input: [ParsingTableToken]! {
        didSet {
            if let input = input {
                var array = input
                array.append(parsingTable.startEndToken)
                inputStream = Queue<ParsingTableToken>(array)
            }
        }
    }
    
    
    init(_ parsingTable: ParsingTable) {
        self.parsingTable = parsingTable
    }
    
    
    func parse() {
    
        while inputStream.count > 1 || stack.count > 2  {
            if let input = inputStream.front, input.key != parsingTable.startEndToken.key {
                if let relation = parsingTable[stack.top!, input] {
                    makeSnapshot(stack, relation, inputStream)
                    if relation != .moreThan  {
                        stack.push(input)
                        let _ = inputStream.dequeue()
                    } else {
                        let _ = minimize()
                    }
                } else {
//                    if !minimize() {
                        let nextToken = input as! Token
                        let index = self.input.index { key in
                            if let token = key as? Token {
                                return token == nextToken
                            }
                            return false
                        }
                        let prev = self.input[self.input.index(before: index!)] as! Token
                        let mistake = SyntaxMistake(nextToken.position, prev.content, nextToken.content)
                        mistakes.append(mistake)
                        return
//                    }
                }
            } else {
                let _ = minimize()
            }
        }
        
        if let last = snapshots.last {
            let added = last.inputStreamDescription.trimmingCharacters(in:CharacterSet(charactersIn: "#"))
            let stack = last.stackDescription + added
            let snapshot = ParserSnapshot(stack, Relation.moreThan.description, "#")
            snapshots.append(snapshot)
        }
        
        
        
        
        
//        while !stack.isEmpty && stack.top?.key != "<root>" {
//            makeSnapshot(stack, relation, inputStream)
//            minimize()
//        }
        
        
        if let top = stack.top, top.key != "<root>" {
            if let last = input.last as? Token {
                let newPoint = TextPoint(line: last.position.line, character: last.position.character)
                let mistake = UnexpectedEndOfFile(newPoint)
                mistakes.append(mistake)
            }
        }
    }
    
    private func minimize() -> Bool {
        var ruleCandidate = [String]()
        var isMinimized = false
        while !stack.isEmpty && stack.top?.key != "<root>" {
            let previous = stack.pop()!
            ruleCandidate.append(previous.key)
            
            if let next = stack.top {
                if let relation = parsingTable.value(for: next, previous), relation == .lessThan {
                    if let minimized = parsingTable.nonTerminal(for: ruleCandidate.reversed()) {
//                        makeSnapshot(stack, relation, inputStream)
                        stack.push(minimized)
                        isMinimized = true
                    }
                    break
                }
            }
        }
        
        return isMinimized
    }
    
    private func makeSnapshot(_ stack: Stack<ParsingTableToken>, _ relation: Relation, _ inputStream: Queue<ParsingTableToken>) {
        let stackDescription = description(from: stack.array)
        let relationDescription = relation.description
        let inputStreamDescription = description(from: inputStream.array)
        let snapshot = ParserSnapshot(stackDescription, relationDescription, inputStreamDescription)
        snapshots.append(snapshot)
    }
    
    
    private func description(from array:[ParsingTableToken]) -> String {
        return array.reduce("") { result, next in
            if let next = next as? Token {
                return "\(result) \(next.content)"
            } else {
                return "\(result) \(next.key)"
            }
        }
    }
}





