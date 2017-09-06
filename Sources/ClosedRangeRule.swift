//
//  ClosedRangeRule.swift
//  SwiftValidator
//
//  Created by Maxim Zaks on 06.09.17.
//
//

import Foundation

public class ClosedRangeRule<T: Comparable>: Rule {
    
    private let range: ClosedRange<T>
    
    public init(range: ClosedRange<T>) {
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
