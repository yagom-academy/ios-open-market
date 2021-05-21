//
//  FormData.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/12.
//

import Foundation

protocol FormData: RequestData {
    var textFields: [(key: String, value: String)] { get }
    var fileFields: [(key: String, value: Data)] { get }
    var codingKeys: [String: String] { get }
}

extension FormData {
    var textFields: [(key: String, value: String)] {
        var fields: [(String, String)] = []

        for (key, value) in Mirror(reflecting: self).children {
            guard let key = key,
                  let codingKey = codingKeys[key],
                  !(value is Data || value is [Data]) else { continue }

            if let text = value as? String {
                fields.append((codingKey, text))
            } else if let number = value as? NSNumber {
                fields.append((codingKey, number.description))
            }
        }

        return fields
    }

    var fileFields: [(key: String, value: Data)] {
        var fields: [(String, Data)] = []

        for (key, value) in Mirror(reflecting: self).children {
            guard let key = key,
                  let codingKey = codingKeys[key],
                  value is Data || value is [Data] else { continue }

            if let value = value as? Data {
                fields.append((codingKey, value))
            } else if let value = value as? [Data] {
                value.forEach({ fields.append((codingKey, $0)) })
            }
        }

        return fields
    }
}
