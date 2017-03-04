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
            IFADuplicationTestClass("Test Copy"),
            ]), 1)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test Copy"),
//            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), 1)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
//            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), 1)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
//            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), 2)
        
        XCTAssertEqual(IFADuplicationUtils.highestCopySequence(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Test Copy 23"),
//            IFADuplicationTestClass("Unrelated Copy 99"),
            ]), 23)

    }
    
    func testName() {
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            ]), "Test Copy")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            ]), "Test Copy 2")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            ]), "Test Copy 3")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Test Copy 23"),
            ]), "Test Copy 24")
        
        XCTAssertEqual(IFADuplicationUtils.name(forDuplicateOf: IFADuplicationTestClass("Test"), inItems: [
            IFADuplicationTestClass("Test"),
            IFADuplicationTestClass("Test Copy"),
            IFADuplicationTestClass("Test Copy 2"),
            IFADuplicationTestClass("Test Copy 23"),
//            IFADuplicationTestClass("Unrelated Copy 56 Copy 34"),
            ]), "Test Copy 24")
        
    }

}

class IFADuplicationTestClass: IFADuplication {
    var name: String?
    init(_ name: String) {
        self.name = name
    }
}
