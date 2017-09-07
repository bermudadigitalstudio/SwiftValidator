//
//  DoubleRule.swift
//  SwiftValidator
//
//  Created by Maxim Zaks on 07.09.17.
//
//

import Foundation
public class DoubleRule: Rule {
    
    private let min: Double
    private let max: Double
    
    private(set) public var validatedValue: Any?
    
    public init(min: Double, max: Double) {
        self.min = min
        self.max = max
    }
    
    public func validate(value: Any) -> Bool {
        var number: Double?
        if let d = value as? Double {
            number = d
        } else if let s = value as? String {
            number = parseNumber(s)
        }
        
        guard let n = number, n >= min, n <= max  else { return false }
        
        validatedValue = n
        
        return true
    }
    
    public func errorMessage() -> String {
        return "Enter a valid number between \(min) and \(max)"
    }
}
