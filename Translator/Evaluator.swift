//
//  Evaluator.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

class Evaluator {
    
    static let identifierPattern = "[A-Za-z]\\w*"
    static let constantPattern = "[0-9]+"
    
    let terminals: Set<String> = ["program", "@", "var", "begin", "end", "integer", "read", "write", "if", "else", "endif", "or", "and", "not", "for", "to", "step", "do", "next", ",", ":", ":=", "-", "+", "*", "/", "^", "(", ")", "[", "]", "<", ">", "<=", ">=", "==", "<>", "\\n", " ", "!", "\\t"]
    
    let identifierRegex: NSRegularExpression
    let constantRegex: NSRegularExpression
    
    
    init() {
        try! self.identifierRegex = NSRegularExpression(pattern: Evaluator.identifierPattern)
        try! self.constantRegex = NSRegularExpression(pattern: Evaluator.constantPattern)
    }
    
    
    
    func evaluate(_ token: String) -> LexemeType? {
        var result: LexemeType?
        
        switch token {
        case _ where isTerminal(token):
            result = .terminal
        case _ where isIdentifier(token):
            result = .identifier
        case _ where isConstant(token):
            result = .constant
        default:
            break
        }
        
        return result
    }
    
    
    /// Checks if token is matches by identifier pattern. 
    /// 
    /// - important: Method doesn't check if token can be a terminal,
    /// so, if you pass teminal matches with the identifier pattern
    /// as paarameter method will return true.
    ///
    /// - Parameter token: token text representation.
    /// - Returns: *true* if it is terminal, otherwise *false*.
    func isIdentifier(_ token: String) -> Bool {
        return check(token, by: identifierRegex)
    }
    
    
    /// Checks if token is constant.
    ///
    /// - Parameter token: token text representation.
    /// - Returns: *true* if it is constant, otherwise *false*.
    func isConstant(_ token: String) -> Bool {
        return check(token, by: constantRegex)
    }
    
    
    /// Checks if token is terminal
    ///
    /// - Parameter token: token text representation.
    /// - Returns: *true* if its terminal, otherwise *false*.
    func isTerminal(_ token: String) -> Bool {
        return terminals.contains(token)
    }
    
    
    /// Checks token using regex
    ///
    /// - Parameters:
    ///   - token: token to check
    ///   - regex: regex used to check
    /// - Returns: *true* if token fully matches the regex, otherwise *false*.
    func check(_ token: String, by regex: NSRegularExpression) -> Bool {
        let range = token.range

        let match = regex.rangeOfFirstMatch(in: token, range: range)
        return NSEqualRanges(match, range)
    }
}
