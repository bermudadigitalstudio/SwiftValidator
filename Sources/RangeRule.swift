//
//  RangeRule.swift
//  SwiftValidator
//
//  Created by Maxim Zaks on 06.09.17.
//
//

import Foundation

public class RangeRule<T: Comparable>: Rule {
    
    private let range: Range<T>
    
    public init(range: Range<T>) {
        self.range = range
    }
    
    public func validate(value: Any) -> Bool {
        guard let t = value as? T else {
            return false
        }
        return range.contains(t)
    }
    
    public func errorMessage() -> String {
        return "Must be in range: \(range)"
    }
}
