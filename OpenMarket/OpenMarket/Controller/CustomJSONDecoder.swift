//
//  CustomJSONDecoder.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/01.
//

import UIKit

enum JSONError: Error {
    case invalidData
    case decodingFailed
}

class CustomJSONDecoder: JSONDecoder {
    static func receiveDataAsset(assetName: String) throws -> NSDataAsset {
        guard let assetData = NSDataAsset(name: assetName) else {
            throw JSONError.invalidData
        }
        return assetData
    }

//    static func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
//        guard let decodedData = try? JSONDecoder().decode(type, from: data) else {
//            throw JSONError.decodingFailed
//        }
//        return decodedData
//
}

extension JSONError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidData:
            return "invalid data"
        case .decodingFailed:
            return "decoding is failed"
        }
    }
}
