//
//  TypedNotificationTests.swift
//  IFAFoundation
//
//  Created by Marcelo Schroeder on 14/8/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

import XCTest
import IFAFoundation

class TypedNotificationTests: XCTestCase {
    
    func testNotificationWithoutParameter() {
        // given
        var notificationReceived: Bool = false
        let token = TestTypedNotification.addObserver(TestTypedNotification.one) {
            notificationReceived = true
        }
        let notification = TestTypedNotification.one
        // when
        notification.post()
        // then
        XCTAssertTrue(notificationReceived)
        TestTypedNotification.removeObserver(token)
    }
    
    func testNotificationWithParameter() {
        // given
        var actualTestParameter: String?
        let token = TestTypedNotification.addObserver(TestTypedNotification.two) { (testParameter) in
            actualTestParameter = testParameter
        }
        let notification = TestTypedNotification.two(testParameter: "test")
        // when
        notification.post()
        // then
        XCTAssertEqual(actualTestParameter, "test")
        TestTypedNotification.removeObserver(token)
    }
    
    func testRemoveObserver() {
        // given
        var notificationReceived: Bool = false
        let token = TestTypedNotification.addObserver(TestTypedNotification.one) {
            notificationReceived = true
        }
        let notification = TestTypedNotification.one
        TestTypedNotification.removeObserver(token)
        // when
        notification.post()
        // then
        XCTAssertFalse(notificationReceived)
    }
    
    func testNotificationWithObjectMatching() {
        // given
        let testObject = TestClass()
        var actualTestObject: TestClass?
        let token = TestTypedNotification.addObserver(TestTypedNotification.three, object: testObject) { (testObject) in
            actualTestObject = testObject
        }
        let notification = TestTypedNotification.three(testObject: testObject)
        // when
        notification.post()
        // then
        XCTAssertTrue(actualTestObject === testObject)
        TestTypedNotification.removeObserver(token)
    }
    
    func testNotificationWithObjectNotMatching() {
        // given
        let objectForObserver = TestClass()
        let objectForNotification = TestClass()
        var notificationReceived: Bool = false
        let token = TestTypedNotification.addObserver(TestTypedNotification.three, object: objectForObserver) { (_) in
            notificationReceived = true
        }
        let notification = TestTypedNotification.three(testObject: objectForNotification)
        // when
        notification.post()
        // then
        XCTAssertFalse(notificationReceived)
        TestTypedNotification.removeObserver(token)
    }
    
    func testThatObserverIsRemovedOnDeinit() {
        // given
        var notificationReceived: Bool = false
        var token: TypedNotificationObserver? = TestTypedNotification.addObserver(TestTypedNotification.one) {
            notificationReceived = true
        }
        let notification = TestTypedNotification.one
        XCTAssertNotNil(token)  // To silence not used warning
        token = nil // Deinit
        // when
        notification.post()
        // then
        XCTAssertFalse(notificationReceived)
    }
    
}

fileprivate enum TestTypedNotification {
    case one
    case two(testParameter: String)
    case three(testObject: TestClass)
}

extension TestTypedNotification: TypedNotification {
    public var name: String {
        switch self {
        case .one:
            return "com.infoaccent.foundation.one"
        case .two:
            return "com.infoaccent.foundation.two"
        case .three:
            return "com.infoaccent.foundation.three"
        }
    }
    public var object: Any? {
        switch self {
        case .three(let testObject):
            return testObject
        default:
            return nil
        }
    }
    public var content: TypedNotificationContent? {
        switch self {
        case .two(let testParameter):
            return testParameter
        case .three(let testObject):
            return testObject
        default:
            return nil
        }
    }
}

fileprivate class TestClass: TypedNotificationContent {
    required init() {
    }
}
