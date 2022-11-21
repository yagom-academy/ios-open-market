//
//  FormatConverter.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/21.
//

import Foundation

struct FormatConverter {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    func date(from string: String) -> Date? {
        if let result = dateFormatter.date(from: string) {
            return result
        }
        return nil
    }
}
