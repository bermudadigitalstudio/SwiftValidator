//
//  Rule.swift
//  Aurora
//
//  Created by Laurent Gaches on 12/04/2017.
//
//

import Foundation

public protocol Rule {
    func validate(value: Any) -> Bool
    func errorMessage() -> String
}
