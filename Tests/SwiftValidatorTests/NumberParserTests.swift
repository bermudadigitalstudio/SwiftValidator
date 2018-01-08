//
//  NumberExtractorTests.swift
//  SwiftValidator
//
//  Created by Maxim Zaks on 07.09.17.
//
//

import XCTest
import SwiftValidator

class NumberParserTests: XCTestCase {

    func testParsing() {
        XCTAssertEqual(parseNumber("1")!, 1.0, accuracy: 0.1)
        XCTAssertEqual(parseNumber("1 kwH")!, 1.0, accuracy: 0.1)
        XCTAssertEqual(parseNumber("-1 kwH")!, -1.0, accuracy: 0.1)
        XCTAssertEqual(parseNumber("-1024 kwH")!, -1024.0, accuracy: 0.1)
        XCTAssertEqual(parseNumber("ich verbrauche 1024,5 kwH")!, 1024.5, accuracy: 0.1)
        XCTAssertEqual(parseNumber("ich - verbrauche - 1024,5 kwH")!, -1024.5, accuracy: 0.1)
        XCTAssertEqual(parseNumber("ich - verbrauche -- 1024,5 kwH")!, 1024.5, accuracy: 0.1)
        XCTAssertEqual(parseNumber("bla 1b22")!, 1, accuracy: 0.1)
        XCTAssertEqual(parseNumber("bla -1-b22")!, -1, accuracy: 0.1)
        XCTAssertEqual(parseNumber("1234.564")!, 1234564, accuracy: 0.1)
        XCTAssertEqual(parseNumber("Ich, glaube. 1234.564")!, 1234564, accuracy: 0.1)
        XCTAssertEqual(parseNumber("Ich, glaube. 1234.564,564")!, 1234564.564, accuracy: 0.001)
        XCTAssertEqual(parseNumber("Ich, glaube. 1234.564,564.45")!, 1234564.564, accuracy: 0.001)
        XCTAssertEqual(parseNumber("Ich, glaube. 1234.564,564,45")!, 1234564.564, accuracy: 0.001)
        XCTAssertEqual(parseNumber("bla bla"), nil)
        XCTAssertEqual(parseNumber(""), nil)
    }
    static var allTests = [
        ("testParsing", testParsing)
    ]
}
