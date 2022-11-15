//
//  String+.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

extension String {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        return formatter
    }
    
    func date() -> Date? {
        if let result = dateFormatter.date(from: self) {
            return result
        }
        return nil
    }
}
