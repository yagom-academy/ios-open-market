//
//  FormData.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/12.
//

import Foundation

protocol FormData {
    var textFields: [String: String] { get }
    var fileFields: [String: Data] { get }
}

extension FormData {
    var textFields: [String: String] {
        var fields: [String: String] = [:]

        for (key, value) in Mirror(reflecting: self).children {
            guard let key = key,
                  !(value is Data || value is [Data]),
                  let realValue = value as Any?,
                  let text = realValue as? CustomStringConvertible else { continue }

            fields.updateValue(text.description, forKey: key)
        }

        return fields
    }

    var fileFields: [String: Data] {
        var fields: [String: Data] = [:]

        for (key, value) in Mirror(reflecting: self).children {
            guard let key = key,
                  value is Data || value is [Data] else { continue }

            if let value = value as? Data {
                fields.updateValue(value, forKey: key)
            } else if let value = value as? [Data] {
                value.forEach({ fields.updateValue($0, forKey: key) })
            }
        }

        return fields
    }
}
