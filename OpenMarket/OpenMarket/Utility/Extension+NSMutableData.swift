//
//  Extension+NSMutableData.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/06.
//

import Foundation

extension NSMutableData {
    
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
