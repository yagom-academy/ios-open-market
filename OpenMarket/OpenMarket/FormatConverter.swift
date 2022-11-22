//
//  FormatConverter.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/21.
//

import Foundation

struct FormatConverter {
    static private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    static func date(from string: String) -> Date? {
        if let result = dateFormatter.date(from: string) {
            return result
        }
        return nil
    }
    
    static private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    static func number(from double: Double) -> String {
        if let result = numberFormatter.string(for: double) {
            return result
        }
        return String(double)
    }
}
