//
//  IntegerRule.swift
//  Aurora
//
//  Created by Laurent Gaches on 12/04/2017.
//
//

import Foundation

public class IntegerRule: Rule {

    let min: Int
    let max: Int

    private(set) public var validatedValue: Any?

    public init(min: Int, max: Int) {
        self.min = min
        self.max = max
    }

    public func validate(value: Any) -> Bool {
        var number: Int?
        if let i = value as? Int {
            number = i
        } else if let s = value as? String,
            let d = parseNumber(s) {
            number = Int(d)
        }
        guard let n = number, n >= min, n <= max  else { return false }
        validatedValue = n
        return true
    }

    public func errorMessage() -> String {
        return "Enter a valid number between \(min) and \(max)"
    }
}
