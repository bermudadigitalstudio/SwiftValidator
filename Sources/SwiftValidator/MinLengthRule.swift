//
//  MinLengthRule.swift
//  Nebula
//
//  Created by Laurent Gaches on 18/04/2017.
//
//

import Foundation

public class MinLengthRule: Rule {

    let min: Int

    private(set) public var validatedValue: Any?

    public init(min: Int) {
        self.min = min
    }

    public func validate(value: Any) -> Bool {
        guard let value = value as? String, value.count >= min  else { return false }
        validatedValue = value
        return true
    }

    public func errorMessage() -> String {
        return "Must be at least \(min) characters long"
    }
}
