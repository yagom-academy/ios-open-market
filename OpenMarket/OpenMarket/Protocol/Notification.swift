//
//  Notification.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/06/01.
//

import Foundation

protocol NotificationObservable: AnyObject {}
protocol NotificationPostable: AnyObject {}

extension NotificationObservable {
    func registerNotification(completion: @escaping () -> ()) {
        NotificationCenter.default.addObserver(forName: .updateData, object: nil, queue: .main) { _ in
            completion()
        }
    }
}

extension NotificationPostable {
    func postNotification() {
        NotificationCenter.default.post(name: .updateData, object: nil)
    }
}
