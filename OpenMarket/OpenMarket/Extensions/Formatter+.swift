//
//  Formatter+.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/16.
//

import Foundation

extension Formatter {
    static let customDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter
    }()
}
