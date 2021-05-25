//
//  NotificationNames.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/22.
//

import Foundation

enum NotificationNames: String {
    case items = "items"
    
    var notificaion: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
