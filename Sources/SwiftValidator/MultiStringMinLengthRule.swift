//
//  MultiStringMinLengthRule.swift
//  SwiftValidator
//
//  Created by Maxim Zaks on 11.09.17.
//
//

import Foundation

public class MultiStringMinLengthRule: Rule {
    
    let minLengths: [Int]
    let separator: CharacterSet
    var error: String?
    
    public init(separator: CharacterSet, length: [Int]) {
        self.separator = separator
        self.minLengths = length
    }
    public init(separator: CharacterSet, length: Int...) {
        self.separator = separator
        self.minLengths = length
    }
    
    public var validatedValue: Any?
    public func validate(value: Any) -> Bool {
        guard let string = value as? String else {
            error = "\(value) is not a string"
            return false
        }
        let strings = string.components(separatedBy: separator).filter { (s) -> Bool in
            return s.characters.isEmpty == false
        }
        guard strings.count >= minLengths.count else {
            error = "Expected string to be separated into \(minLengths.count) parts, but was only \(strings.count)"
            return false
        }
        for i in 0..<minLengths.count {
            if strings[i].characters.count < minLengths[i] {
                error = "`\(strings[i])` is shorter than \(minLengths[i])"
                return false
            }
        }
        validatedValue = strings
        return true
    }
    public func errorMessage() -> String {
        return error ?? ""
    }
}
