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
    var object: Any? { get }
    var content: TypedNotificationContent? { get }
}

/// TypedNotification's content conformance
public protocol TypedNotificationContent {
    init()
}

/// An opaque object to act as the observer
public class TypedNotificationObserver {
    fileprivate let observer: NSObjectProtocol
    fileprivate let notificationCentre: NotificationCenter
    
    fileprivate init(observer: NSObjectProtocol, notificationCentre: NotificationCenter) {
        self.observer = observer
        self.notificationCentre = notificationCentre
    }

    deinit {
        self.notificationCentre.removeObserver(observer)
    }
}

public extension TypedNotification {

    var object: Any? {
        return nil
    }

    var content: TypedNotificationContent? {
        return nil
    }
    
    /// Posts notification represented by the receiver.
    public func post(notificationCentre: NotificationCenter = NotificationCenter.default) {
        type(of: self).post(self, notificationCentre: notificationCentre)
    }
    
    /**
     Posts the notification received as the parameter.
     */
    public static func post(_ notification: Self, notificationCentre: NotificationCenter = NotificationCenter.default) {
        let name = Notification.Name(rawValue: notification.name)
        let userInfo = notification.content.map({ ["content": $0] })
        notificationCentre.post(name: name, object: notification.object, userInfo: userInfo)
    }
    
    /**
     Adds an observer closure with no input parameters for a given typed notification type.
     - parameter notificationType: The type of notification to observe.
     - parameter object: The object whose notifications the observer wants to receive; that is, only notifications sent by this sender are delivered to the observer.
     - parameter queue: The operation queue to which block should be added. If you pass nil, the block is run synchronously on the posting thread.
     - parameter block: Closure to execute upon receiving the notification.
     - returns: An opaque object to act as the observer
     */
    public static func addObserver(_ notificationType: Self, notificationCentre: NotificationCenter = NotificationCenter.default, object: Any? = nil, queue: OperationQueue? = nil, using block: @escaping () -> Void) -> TypedNotificationObserver {
        let name = Notification.Name(rawValue: notificationType.name)
        let observer = notificationCentre.addObserver(forName: name, object: object, queue: queue) { notification in
            block()
        }
        return TypedNotificationObserver(observer: observer, notificationCentre: notificationCentre)
    }

    /**
     Adds an observer closure that receives the content of a given typed notification type.
     - parameter notificationType: The type of notification to observe.
     - parameter object: The object whose notifications the observer wants to receive; that is, only notifications sent by this sender are delivered to the observer.
     - parameter queue: The operation queue to which block should be added. If you pass nil, the block is run synchronously on the posting thread.
     - parameter block: Closure to execute upon receiving the notification.
     - returns: An opaque object to act as the observer
     */
    public static func addObserver <ContentType: TypedNotificationContent> (_ notificationType: (ContentType) -> Self, notificationCentre: NotificationCenter = NotificationCenter.default, object: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (ContentType) -> Void) -> TypedNotificationObserver {
        let name = Notification.Name(rawValue: notificationType(ContentType()).name)
        let observer = notificationCentre.addObserver(forName: name, object: object, queue: queue) { notification in
            if let content = notification.userInfo?["content"] as? ContentType {
                block(content)
            }
        }
        return TypedNotificationObserver(observer: observer, notificationCentre: notificationCentre)
    }
    
    /**
     Removes given observer.
     - parameter observer: Observer to remove.
     */
    public static func removeObserver(_ observer: TypedNotificationObserver, notificationCentre: NotificationCenter = NotificationCenter.default) {
        notificationCentre.removeObserver(observer.observer)
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
