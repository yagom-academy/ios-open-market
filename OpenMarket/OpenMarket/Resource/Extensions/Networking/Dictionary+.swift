//
//  Dictionary+.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

extension Dictionary where Key == String, Value == String {
    func asParameters() -> [URLQueryItem] {
        return self.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
}
