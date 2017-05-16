//
//  StringNSrangeToRangeBridge.swift
//  Translator
//
//  Created by Dmytro Polishchuk on 5/16/17.
//  Copyright © 2017 Dmytro Polishchuk. All rights reserved.
//

import Foundation

extension String {

    
    /// Returns a string object containing the characters of the String that lie within a given range.
    ///
    /// - Parameter range: range to convert.
    /// - Returns: string if NSRange instance can be applied to this string, otherwise - nil.
    func substring(with range: NSRange) -> String? {
        guard let range = range.toRange()
            else { return nil }
        let start = UTF16Index(range.lowerBound)
        let end = UTF16Index(range.upperBound)
        return String(utf16[start..<end])
    }
    
    
    /// Converts  `NSRange` to `Range<String.Index>` instance.
    ///
    /// - Parameter nsrange: `NSRange` instance to convert.
    /// - Returns: `Range<String.Index>` if range can be converted for this string, otherwise nil.
    func range(from range: NSRange) -> Range<Index>? {
        guard let range = range.toRange() else { return nil }
        
        let utf16Start = UTF16Index(range.lowerBound)
        let utf16End = UTF16Index(range.upperBound)
        
        guard let start = Index(utf16Start, within: self),
            let end = Index(utf16End, within: self)
            else { return nil }
        
        return start..<end
    }
    
    
    /// Converts `Range<String.Index>` to `NSRange` instance.
    ///
    /// - Parameter range: Range<String.Index> for specified string.
    /// - Returns: NSRange for string.
    func range(from range: Range<Index>) -> NSRange {
        let lower = UTF16View.Index(range.lowerBound, within: utf16)
        let upper = UTF16View.Index(range.upperBound, within: utf16)
        
        return NSRange(location: utf16.startIndex.distance(to: lower), length: lower.distance(to: upper))
    }
}
