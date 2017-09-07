import XCTest
@testable import SwiftValidatorTests

XCTMain([
    testCase(ValidatorTests.allTests),
    testCase(NumberParserTests.allTests)
])
