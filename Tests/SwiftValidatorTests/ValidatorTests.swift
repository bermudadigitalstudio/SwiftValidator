import XCTest
@testable import SwiftValidator

class ValidatorTests: XCTestCase {

    func testZipRule() {
        let zipCodeRule = ZipCodeRule()

        XCTAssertTrue(zipCodeRule.validate(value: "31500"), "PASS")
        XCTAssertFalse(zipCodeRule.validate(value: "315000"), "TOO LONG")
        XCTAssertFalse(zipCodeRule.validate(value: "315"), "TOO SHORT")
        XCTAssertFalse(zipCodeRule.validate(value: "aR31500"), "WRONG FORMAT")
        XCTAssertFalse(zipCodeRule.validate(value: "qwert"), "ONLY NUMBERS")
        XCTAssertFalse(zipCodeRule.validate(value: 31500))
    }

    func testIBANRule() {
        let ibanRule = IBANRule()

        let validIBAN = ["DE44500105175407324931",
                         "DE44 5001 0517 5407 3249 31",
                         "GB82 WEST 1234 5698 7654 32",
                         "FR1420041010050500013M02606"]

        validIBAN.forEach {
            XCTAssertTrue(ibanRule.validate(value: $0))
        }

        let invalidIBAN:[Any] = ["A",
                                 "DE4450010517540732493",
                                 44500105,
                                 "ES9121000418450200051332",
                                 "FR1420041010050500013N02606"]

        invalidIBAN.forEach {
            XCTAssertFalse(ibanRule.validate(value: $0))
        }

    }


    func testIntegerRule() {
        let intRule = IntegerRule(min: 10, max: 250)

        [10,250,100].forEach {
            XCTAssertTrue(intRule.validate(value: $0))
        }

        [500,9].forEach {
            XCTAssertFalse(intRule.validate(value: $0))
        }
    }

    static var allTests = [
        ("testZipRule", testZipRule),
        ("testIBANRule", testIBANRule),
        ("testIntegerRule", testIntegerRule)
    ]
}
