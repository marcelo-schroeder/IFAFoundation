//
// Created by Marcelo Schroeder on 3/3/17.
// Copyright (c) 2017 InfoAccent Pty Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import IFAFoundation

class IFADuplicationTests: XCTestCase {
    
    func testSignificantDuplicationRegexGroup() {

        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report"), nil)
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report Copy"), "Copy")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report Copy 2"), "2")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report Copy 23"), "23")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Copy Report"), nil)
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Copy 23 Report"), nil)
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Report Copy 12 Copy 23"), "23")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: nil), nil)
    
    }
    
    func testHighestCopySequence() {

        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(inItems: []), 0)
    
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(inItems: [
            IFADuplicationTestClass("Test"),
            ]), 0)

        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(inItems: [
            IFADuplicationTestClass("Test Copy"),
            ]), 1)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            ]), 1)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            ]), 2)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Test Copy 23"),
            ]), 23)

    }
    
    func testName() {
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), existingItems: [
            IFADuplicationTestClass("Test"),
            ]), "Test Copy")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), existingItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            ]), "Test Copy 2")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), existingItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            ]), "Test Copy 3")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), existingItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Test Copy 23"),
            ]), "Test Copy 24")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), existingItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Test Copy 23"),
            IFADuplicationTestClass("Report Copy 45 Copy 23"),
            ]), "Test Copy 24")
        
    }

}

class IFADuplicationTestClass: IFADuplication {
    var name: String?
    init(_ name: String) {
        self.name = name
    }
}
