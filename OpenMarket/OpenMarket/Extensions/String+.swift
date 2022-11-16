//
//  String+.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/16.
//

import Foundation

extension String {
    func stringWithFormatter() -> Date? {
        return Formatter.customDateFormat.date(from: self)
    }
}
