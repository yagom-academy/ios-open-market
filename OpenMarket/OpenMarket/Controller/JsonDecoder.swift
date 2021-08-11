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
    func decodeJsonFromData<T: Decodable>(type: T.Type, data: Data) throws -> T
}

protocol MockDecoder: Decoder {
    func receiveDataAsset(assetName: String) throws -> NSDataAsset
}

struct JsonDecoder<T: Decodable> {
    static func decodeJsonFromDataAsset(type: T.Type, assetName: String) throws -> T {
        guard let dataAsset = NSDataAsset(name: assetName) else {
            throw JsonError.invalidData
        }
        guard let decodedData = try? JSONDecoder().decode(type, from: dataAsset.data) else {
            throw JsonError.decodingFailed
        }
        return decodedData
    }
    
    static func decodedJsonFromURLData(type: T.Type, data: Data) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(type, from: data) else {
            throw JsonError.decodingFailed
        }
        return decodedData
    }
}
