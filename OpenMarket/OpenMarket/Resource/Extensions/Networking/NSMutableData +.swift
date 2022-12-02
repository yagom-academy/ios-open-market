//
//  NSMutableData.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.
        

import Foundation

extension NSMutableData {
    func appendString(_ value: String) {
        if let data = value.data(using: .utf8) {
            self.append(data)
        }
    }
}
