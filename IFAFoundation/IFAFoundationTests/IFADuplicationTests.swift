//
// Created by Marcelo Schroeder on 3/3/17.
// Copyright (c) 2017 InfoAccent Pty Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import IFAFoundation

class IFADuplicationTests: XCTestCase {

    func testName() {

        // Given
        let duplicateSource = IFADuplicationTestClass("Test")
        let existingItems: Array<IFADuplication> = [duplicateSource]

        // When
        let result = IFADuplicationUtils.name(forDuplicateOf: duplicateSource, existingItems: existingItems)

        // Then
        XCTAssertEqual(result, "Test Copy 1", "")

    }
    
    func testSignificantDuplicationRegexGroup() {
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report"), nil)
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report Copy"), "Copy")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report Copy 2"), "2")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report Copy 23"), "23")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Copy Report"), nil)
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Copy 23 Report"), nil)
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report Copy 12 Copy 23"), "23")
    }

}

class IFADuplicationTestClass: IFADuplication {
    var name: String?
    init(_ name: String) {
        self.name = name
    }
}
