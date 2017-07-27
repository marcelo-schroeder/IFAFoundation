//
// Created by Marcelo Schroeder on 3/3/17.
// Copyright (c) 2017 InfoAccent Pty Ltd. All rights reserved.
//

import Foundation
import XCTest
@testable import IFAFoundation

class IFADuplicationTests: XCTestCase {
    
    func testSignificantDuplicationRegexGroup() {

        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Test"), nil)
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Test Copy"), "Copy")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Test Copy 2"), "2")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Test Copy 23"), "23")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Copy Report"), nil)
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Copy 23 Report"), nil)
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: "Test Copy 12 Copy 23"), "23")
        XCTAssertEqual(IFADuplicationUtils.significantDuplicationRegexGroup(forName: nil), nil)
    
    }
    
    func testHighestCopySequence() {

        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: []), 0)
    
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            ]), 0)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test "),
            ]), 0)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Unrelated Copy"),
            ]), 0)

        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test Copy"),
            ]), 1)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), 1)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), 1)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), 2)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Test Copy 23"),
            IFADuplicationTestClass("Test Copy 1 Copy 2 Copy 3"),
            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), 23)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test Copy 1 Copy 2"), inItems: [
            IFADuplicationTestClass("Test Copy 1 Copy 2"),
            IFADuplicationTestClass("Test Copy 1 Copy 4"),
            IFADuplicationTestClass("Test Copy 7 Copy 8 Copy 9"),
            ]), 4)

    }
    
    func testName() {
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            ]), "Test Copy")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test "),
            ]), "Test Copy")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Unrelated Copy"),
            ]), "Test Copy")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test Copy"),
            ]), "Test Copy 2")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), "Test Copy 2")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), "Test Copy 2")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), "Test Copy 3")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Test Copy 23"),
            IFADuplicationTestClass("Test Copy 1 Copy 2 Copy 3"),
            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), "Test Copy 24")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test Copy 1 Copy 2"), inItems: [
            IFADuplicationTestClass("Test Copy 1 Copy 2"),
            IFADuplicationTestClass("Test Copy 1 Copy 4"),
            IFADuplicationTestClass("Test Copy 7 Copy 8 Copy 9"),
            ]), "Test Copy 1 Copy 5")
        
    }

}

class IFADuplicationTestClass: IFADuplication {
    var uniqueNameForDuplication: String?
    init(_ name: String) {
        self.uniqueNameForDuplication = name
    }
}
