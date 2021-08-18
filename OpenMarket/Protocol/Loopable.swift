//
//  Loopable.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

protocol Loopable {
    var properties: [String: Any?] { get }
}

extension Loopable {
    var properties: [String: Any?] {
        var dictionary = [String: Any?]()
        
        let mirror = Mirror(reflecting: self)
        
        guard let style = mirror.displayStyle,
              (style == .class || style == .struct) else {
            return dictionary
        }
        
        for (rawKey, value) in mirror.children {
            guard let rawKey = rawKey else { continue }
            
            var key = ""
            
            for character in rawKey {
                if character.isUppercase {
                    key += "_" + character.lowercased()
                } else {
                    key += character.description
                }
            }
            
            let valueMirror = Mirror(reflecting: value)
            
            if valueMirror.displayStyle == .optional,
               let optional = valueMirror.children.first {
                dictionary[key] = optional.value
            } else {
                dictionary[key] = value
            }
        }
        
        return dictionary
    }
}
