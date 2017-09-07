//
//  EmailRule.swift
//  SwiftValidator
//
//  Created by Laurent Gaches on 03/07/2017.
//

import Foundation

public class EmailRule: Rule {

    private let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    private(set) public var validatedValue: Any?

    public func validate(value: Any) -> Bool {
        guard let value = value as? String else { return false }

        guard let regex = try? NSRegularExpression(pattern:emailFormat, options: []) else { return false }
        let matches = regex.numberOfMatches(in:value, options: .anchored,
                                            range: NSRange(location: 0, length: value.utf8.count))

        guard matches == 1 else { return false }

        let valid = matches == 1
        if valid {
            validatedValue = value
        }
        return valid
    }

    public func errorMessage() -> String {
        return "Enter a valid Email"
    }


}
