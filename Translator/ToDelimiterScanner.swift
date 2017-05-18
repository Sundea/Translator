//
//  ToDelimiterScanner.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation


/// Token scanner, that main algorithm is scan up to delimiter
class ToDelimiterScanner: TokenScanner {
    
    // MARK: Static constant
    
    static let delimiterPattern = "<=|>=|==|<>|:=|,|:|-|\\+|\\*|\\/|\\^|\\(|\\)|\\[|]|>|<|\\n|\\s|\\t"
    
    
    // MARK: Properties
    
    /// Regex used to find positions of delimiters in given string
    let delimiterRegex: NSRegularExpression
    
    
    // MARK: Overriden Methods
    
    override init(_ string: String, _ tokensToBeSkipped: Set<String>? = nil) throws {
        try! self.delimiterRegex = NSRegularExpression(pattern: ToDelimiterScanner.delimiterPattern)
        try super.init(string, tokensToBeSkipped)
    }
    
    
    override func scanNext() -> String? {
        var token: String?
        
        while !isAtEnd && token == nil {
            let rangeToScan = string.range(from: scanRange)
            let firstMatchRange = delimiterRegex.rangeOfFirstToken(in: string, range: rangeToScan)
            
            let result = string.substring(with: firstMatchRange)!
            
            if !shouldSkip(result) {
                token = result
            }
            scanLocation = NSMaxRange(firstMatchRange)
        }
        return token
    }
}



fileprivate extension NSRegularExpression {
    
    func rangeOfFirstToken(in string: String, range: NSRange) -> NSRange {
        var firstMatch = self.rangeOfFirstMatch(in: string, range: range)
        
        // check if find something
        
        if NSEqualRanges(firstMatch, NSMakeRange(NSNotFound, 0)) {
        
            // if find nothing, whole string is one token
            firstMatch = range
            
        } else if firstMatch.location > range.location {
            // if location of firstMatch is bigger, it means that delimiter is not at beginnig of the string,
            // something like in this case "text: delimiter"
            // Token we need to produce will be "text", so we should to modify our range.
            firstMatch = NSMakeRange(range.location, firstMatch.location - range.location)
        }
        
        return firstMatch
    }
}
