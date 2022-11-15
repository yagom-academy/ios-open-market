//
//  String+.swift
//  OpenMarket
//
//  Created by Wonbi on 2022/11/15.
//

import Foundation

extension String {
    func date() -> Date? {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
            return formatter
        }()
        
        if let result = dateFormatter.date(from: self) {
            return result
        } else {
            return nil
        }
    }
}
