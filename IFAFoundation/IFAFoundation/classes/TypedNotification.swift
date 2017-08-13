//
//  TypedNotification.swift
//  IFAFoundation
//
//  Created by Marcelo Schroeder on 14/8/17.
//  Copyright © 2017 InfoAccent Pty Ltd. All rights reserved.
//

import Foundation

/// Strongly typed notification inspired by: [Michael Helmbrecht's TypedNotification](https://github.com/mrh-is/PugNotification)
public protocol TypedNotification {
    var name: String { get }
    var content: TypedNotificationContentType? { get }
}

public protocol TypedNotificationContentType {
    init()
}

public class ObserverToken {
    fileprivate let observer: NSObjectProtocol
    
    fileprivate init(observer: NSObjectProtocol) {
        self.observer = observer
    }
}

public extension TypedNotification {

    public func post() {
        type(of: self).post(self)
    }
    
    public static func post(_ notification: Self) {
        let name = Notification.Name(rawValue: notification.name)
        let userInfo = notification.content.map({ ["content": $0] })
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
    public static func addObserver(_ notification: Self, using block: @escaping () -> Void) -> ObserverToken {
        let name = Notification.Name(rawValue: notification.name)
        let observer = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { _ in
            block()
        }
        return ObserverToken(observer: observer)
    }

    public static func addObserver <ContentType: TypedNotificationContentType> (_ notification: (ContentType) -> Self, using block: @escaping (ContentType) -> Void) -> ObserverToken {
        let name = Notification.Name(rawValue: notification(ContentType()).name)
        let observer = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { notification in
            if let content = notification.userInfo?["content"] as? ContentType {
                block(content)
            }
        }
        return ObserverToken(observer: observer)
    }
    
    public static func removeObserver(_ observer: ObserverToken) {
        NotificationCenter.default.removeObserver(observer.observer)
    }

}

extension Int: TypedNotificationContentType {}
extension Float: TypedNotificationContentType {}
extension Double: TypedNotificationContentType {}
extension Bool: TypedNotificationContentType {}
extension String: TypedNotificationContentType {}
extension Array: TypedNotificationContentType {}
extension Dictionary: TypedNotificationContentType {}
extension Set: TypedNotificationContentType {}
