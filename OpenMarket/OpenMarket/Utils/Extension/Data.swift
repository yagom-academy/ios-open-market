//
//  Data.swift
//  OpenMarket
//
//  Created by song on 2022/05/25.
//

import UIKit

extension Data {
    
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
