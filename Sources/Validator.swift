//
//  Validator.swift
//  Aurora
//
//  Created by Laurent Gaches on 12/04/2017.
//
//

import Foundation

public enum RuleType {
    case zipCode
    case integer(Int, Int)
    case minLength(Int)
    case iban
    case email

    var rule: Rule {
        switch self {
        case .zipCode:
            return ZipCodeRule()
        case .integer(let min, let max):
            return IntegerRule(min: min, max: max)
        case .minLength(let min):
            return MinLengthRule(min: min)
        case .iban:
            return IBANRule()
        case .email:
            return EmailRule()
        }

    }
}

public struct Field {
    let name: String
    let rules: [RuleType]
    let required: Bool

    public init(_ name: String, rules: [RuleType], required: Bool = false) {
        self.name = name
        self.rules = rules
        self.required = required
    }
}

public class Validator {

    private var datas: [String: Any]
    private var validators: [Field] = []

    public init(datas: [String: Any]) {
        self.datas = datas
    }

    public func validate(_ fieldName: String, rules: [RuleType], required: Bool = false) {
        validators.append(Field(fieldName, rules: rules, required: required))
    }

    public func validate() -> [String:String] {

        var errors: [String:String] = [:]
        validators.forEach { validator in
            if let fieldValue = datas[validator.name] {
                validator.rules.forEach { rule in
                    if !rule.rule.validate(value: fieldValue) {
                        errors[validator.name] = rule.rule.errorMessage()
                    }
                }
            } else {
                if validator.required {
                    errors[validator.name] = "\(validator.name) is required"
                }
            }
        }
        return errors
    }
}
