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

    public init(min: Int, max: Int) {
        self.min = min
        self.max = max
    }

    public func validate(value: Any) -> Bool {
        guard let value = value as? Int, value >= min, value <= max  else { return false }
        return true
    }

    public func errorMessage() -> String {
        return "Enter a valid number between \(min) and \(max)"
    }
}
