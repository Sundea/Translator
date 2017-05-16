//
//  TokenScanner.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

enum TokenScannerError: Error {
    case emptyString
}

/// Abstract class for token scanner
class TokenScanner {
    
    // MARK: - Properties
    
    /// The string the scanner will scan.
    private(set) var string: String
    
    /// The character position at which the receiver will begin its next scanning operation.
    var scanLocation: Int
    
    
    /// The set of tokens that will skipped by next() -> String? method
    let tokensToBeSkipped: Set<String>?

    
    // MARK: - Init
    
    /// Returns an Token Scanner object initialized to scan a given string.
    ///
    /// - Parameter string: The string to scan.
    /// - Parameter tokensToBeSkipped: The set of tokens that will skipped by next() -> String? method
    /// - Throws: TokenScannerError.emptyString if string is empty
    init(_ string: String, _ tokensToBeSkipped: Set<String>? = nil) throws {
        
        if string.isEmpty {
            throw TokenScannerError.emptyString
        }
        
        self.string = string
        self.scanLocation = 0
        self.tokensToBeSkipped = tokensToBeSkipped
    }
}


// MARK: - Public
extension TokenScanner {
    
    /// Range from scan location to the end of the string
    var scanRange: Range<String.Index> {
        let startIndex = string.index(string.startIndex, offsetBy: scanLocation)
        let range = Range<String.Index>(uncheckedBounds: (lower: startIndex, upper: string.endIndex))
        return range
    }

    
    /// Scans for a token and return it.
    /// Skips all string from strings to skip set
    /// You should override this this method in a subclass
    /// The default implementation does nothing, simply return given string
    ///
    /// - Returns: token if the receiver finds a valid token, othervise nil
    func scanNext() -> String? {
        return string
    }
}


