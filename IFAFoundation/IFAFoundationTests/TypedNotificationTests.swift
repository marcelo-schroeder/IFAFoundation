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
    
    func testNotificationWithoutArgument() {
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
    
    func testNotificationWithArgument() {
        // given
        var actualTestArgument: String?
        let token = TestTypedNotification.addObserver(TestTypedNotification.two) { (testArgument) in
            actualTestArgument = testArgument
        }
        let notification = TestTypedNotification.two(testArgument: "test")
        // when
        notification.post()
        // then
        XCTAssertEqual(actualTestArgument, "test")
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
    case two(testArgument: String)
}

extension TestTypedNotification: TypedNotification {
    public var name: String {
        switch self {
        case .one:
            return "com.infoaccent.foundation.notification.one"
        case .two:
            return "com.infoaccent.foundation.notification.two"
        }
    }
    public var content: TypedNotificationContentType? {
        switch self {
        case .one:
            return nil
        case .two(let testArgument):
            return testArgument
        }
    }
}
