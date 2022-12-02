//
//  OpenMarket - Data+Extension.swift
//  Created by Zhilly, Dragon. 22/12/01
//  Copyright © yagom. All rights reserved.
//

import Foundation

extension Data {
    mutating func appendString(_ value: String) {
        guard let value = value.data(using: .utf8) else { return }
        self.append(value)
    }
}
