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
    var content: TypedNotificationContent? { get }
}

/// TypedNotification's content conformance
public protocol TypedNotificationContent {
    init()
}

/// An opaque object to act as the observer
public class TypedNotificationObserver {
    fileprivate let observer: NSObjectProtocol
    
    fileprivate init(observer: NSObjectProtocol) {
        self.observer = observer
    }
}

public extension TypedNotification {

    /// Posts notification represented by the receiver.
    public func post() {
        type(of: self).post(self)
    }
    
    /**
     Posts the notification received as the parameter.
     */
    public static func post(_ notification: Self) {
        let name = Notification.Name(rawValue: notification.name)
        let userInfo = notification.content.map({ ["content": $0] })
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
    /**
     Adds an observer closure with no input parameters for a given typed notification type.
     - parameter notificationType: The type of notification to observe.
     - parameter block: Closure to execute upon receiving the notification.
     - returns: An opaque object to act as the observer
     */
    public static func addObserver(_ notificationType: Self, using block: @escaping () -> Void) -> TypedNotificationObserver {
        let name = Notification.Name(rawValue: notificationType.name)
        let observer = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { _ in
            block()
        }
        return TypedNotificationObserver(observer: observer)
    }

    /**
     Adds an observer closure that receives the content of a given typed notification type.
     - parameter notificationType: The type of notification to observe.
     - parameter block: Closure to execute upon receiving the notification.
     - returns: An opaque object to act as the observer
     */
    public static func addObserver <ContentType: TypedNotificationContent> (_ notificationType: (ContentType) -> Self, using block: @escaping (ContentType) -> Void) -> TypedNotificationObserver {
        let name = Notification.Name(rawValue: notificationType(ContentType()).name)
        let observer = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { notification in
            if let content = notification.userInfo?["content"] as? ContentType {
                block(content)
            }
        }
        return TypedNotificationObserver(observer: observer)
    }
    
    /**
     Removes given observer.
     - paratert observer: Observer to remove.
     */
    public static func removeObserver(_ observer: TypedNotificationObserver) {
        NotificationCenter.default.removeObserver(observer.observer)
    }

}

extension Int: TypedNotificationContent {}
extension Float: TypedNotificationContent {}
extension Double: TypedNotificationContent {}
extension Bool: TypedNotificationContent {}
extension String: TypedNotificationContent {}
extension Array: TypedNotificationContent {}
extension Dictionary: TypedNotificationContent {}
extension Set: TypedNotificationContent {}
