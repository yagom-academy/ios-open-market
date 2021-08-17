//
//  Loopable.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

protocol Loopable {
    var properties: [String: Any] { get }
}

extension Loopable {
    var properties: [String: Any] {
        var result = [String: Any]()
        
        let mirror = Mirror(reflecting: self)
        
        guard let style = mirror.displayStyle,
              (style == .class || style == .struct) else {
            return result
        }
        
        for (key, value) in mirror.children {
            guard let key = key else { continue }
            
            result[key] = value
        }
        
        return result
    }
}
