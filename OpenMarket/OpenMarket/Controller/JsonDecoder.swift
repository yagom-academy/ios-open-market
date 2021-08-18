//
//  JsonDecoder.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/11.
//

import UIKit

enum JsonError: Error {
    case invalidData
    case decodingFailed
}

protocol Decoder {
    static func decodeJsonFromData<T: Decodable>(type: T.Type, data: Data) throws -> T
}

struct JsonDecoder<T: Decodable> {
    static func decodedJsonFromData(type: T.Type, data: Data) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(type, from: data) else {
            throw JsonError.decodingFailed
        }
        return decodedData
    }
}
