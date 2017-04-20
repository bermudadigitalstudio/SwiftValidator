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

    public init(min: Int) {
        self.min = min
    }

    public func validate(value: Any) -> Bool {
        guard let value = value as? String, value.characters.count >= min  else { return false }
        return true
    }

    public func errorMessage() -> String {
        return "Must be at least \(min) characters long"
    }
}
