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
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
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
    
}

enum TestTypedNotification {
    case one
    case two(testParameter: String)
}

extension TestTypedNotification: TypedNotification {
    public var name: String {
        switch self {
        case .one:
            return "com.infoaccent.foundation.one"
        case .two:
            return "com.infoaccent.foundation.two"
        }
    }
    public var content: TypedNotificationContent? {
        switch self {
        case .one:
            return nil
        case .two(let testParameter):
            return testParameter
        }
    }
}
