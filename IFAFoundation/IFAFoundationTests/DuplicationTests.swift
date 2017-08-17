//
// Created by Marcelo Schroeder on 3/3/17.
// Copyright (c) 2017 InfoAccent Pty Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import IFAFoundation

class DuplicationTests: XCTestCase {
    
    func testSignificantDuplicationRegexGroup() {

        XCTAssertEqual(DuplicationUtils.significantDuplicationRegexGroup(forName: "Test"), nil)
        XCTAssertEqual(DuplicationUtils.significantDuplicationRegexGroup(forName: "Test Copy"), "Copy")
        XCTAssertEqual(DuplicationUtils.significantDuplicationRegexGroup(forName: "Test Copy 2"), "2")
        XCTAssertEqual(DuplicationUtils.significantDuplicationRegexGroup(forName: "Test Copy 23"), "23")
        XCTAssertEqual(DuplicationUtils.significantDuplicationRegexGroup(forName: "Copy Report"), nil)
        XCTAssertEqual(DuplicationUtils.significantDuplicationRegexGroup(forName: "Copy 23 Report"), nil)
        XCTAssertEqual(DuplicationUtils.significantDuplicationRegexGroup(forName: "Test Copy 12 Copy 23"), "23")
        XCTAssertEqual(DuplicationUtils.significantDuplicationRegexGroup(forName: nil), nil)
    
    }
    
    func testHighestCopySequence() {

        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test"), inItems: []), 0)
    
        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            ]), 0)
        
        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Test "),
            ]), 0)
        
        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Unrelated Copy"),
            ]), 0)

        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test Copy"),
            ]), 1)
        
        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test Copy"),
            DuplicationTestClass("Unrelated Copy 99"),
            ]), 1)
        
        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Test Copy"),
            DuplicationTestClass("Unrelated Copy 99"),
            ]), 1)
        
        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Test Copy"),
            DuplicationTestClass("Test Copy 2"),
            DuplicationTestClass("Unrelated Copy 99"),
            ]), 2)
        
        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Test Copy"),
            DuplicationTestClass("Test Copy 2"),
            DuplicationTestClass("Test Copy 23"),
            DuplicationTestClass("Test Copy 1 Copy 2 Copy 3"),
            DuplicationTestClass("Unrelated Copy 99"),
            ]), 23)
        
        XCTAssertEqual(DuplicationUtils.highestCopySequence(forDuplicateOf: DuplicationTestClass("Test Copy 1 Copy 2"), inItems: [
            DuplicationTestClass("Test Copy 1 Copy 2"),
            DuplicationTestClass("Test Copy 1 Copy 4"),
            DuplicationTestClass("Test Copy 7 Copy 8 Copy 9"),
            ]), 4)

    }
    
    func testName() {
        
        XCTAssertEqual(DuplicationUtils.name(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            ]), "Test Copy")
        
        XCTAssertEqual(DuplicationUtils.name(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Test "),
            ]), "Test Copy")
        
        XCTAssertEqual(DuplicationUtils.name(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Unrelated Copy"),
            ]), "Test Copy")
        
        XCTAssertEqual(DuplicationUtils.name(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test Copy"),
            ]), "Test Copy 2")
        
        XCTAssertEqual(DuplicationUtils.name(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test Copy"),
            DuplicationTestClass("Unrelated Copy 99"),
            ]), "Test Copy 2")
        
        XCTAssertEqual(DuplicationUtils.name(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Test Copy"),
            DuplicationTestClass("Unrelated Copy 99"),
            ]), "Test Copy 2")
        
        XCTAssertEqual(DuplicationUtils.name(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Test Copy"),
            DuplicationTestClass("Test Copy 2"),
            DuplicationTestClass("Unrelated Copy 99"),
            ]), "Test Copy 3")
        
        XCTAssertEqual(DuplicationUtils.name(forDuplicateOf: DuplicationTestClass("Test"), inItems: [
            DuplicationTestClass("Test"),
            DuplicationTestClass("Test Copy"),
            DuplicationTestClass("Test Copy 2"),
            DuplicationTestClass("Test Copy 23"),
            DuplicationTestClass("Test Copy 1 Copy 2 Copy 3"),
            DuplicationTestClass("Unrelated Copy 99"),
            ]), "Test Copy 24")
        
        XCTAssertEqual(DuplicationUtils.name(forDuplicateOf: DuplicationTestClass("Test Copy 1 Copy 2"), inItems: [
            DuplicationTestClass("Test Copy 1 Copy 2"),
            DuplicationTestClass("Test Copy 1 Copy 4"),
            DuplicationTestClass("Test Copy 7 Copy 8 Copy 9"),
            ]), "Test Copy 1 Copy 5")
        
    }

}

class DuplicationTestClass: Duplication {
    var uniqueNameForDuplication: String?
    init(_ name: String) {
        self.uniqueNameForDuplication = name
    }
}
