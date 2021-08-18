//
//  MockJsonDecoder.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/18.
//

import UIKit

protocol MockDecoder: Decoder {
    static func receiveDataAsset(assetName: String) throws -> NSDataAsset
}

struct MockJsonDecoder: MockDecoder {
    static func receiveDataAsset(assetName: String) throws -> NSDataAsset {
        guard let assetData = NSDataAsset(name: assetName) else { throw JsonError.invalidData }
        return assetData
    }

    static func decodeJsonFromData<T>(type: T.Type, data: Data) throws -> T where T : Decodable {
        guard let decodedData = try? JSONDecoder().decode(type, from: data) else {
            throw JsonError.decodingFailed
        }
        return decodedData
    }
}
