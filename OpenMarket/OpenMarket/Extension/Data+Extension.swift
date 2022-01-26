//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/26.
//

import Foundation

extension Data {
    mutating func append(string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        
        self.append(data)
    }
}
