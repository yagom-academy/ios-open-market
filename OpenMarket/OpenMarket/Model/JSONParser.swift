//
//  Parser.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/03.
//

import UIKit

struct JSONParser: JSONParserable {
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    func decode<T: Decodable>(fileName: String, decodingType: T.Type) -> Result<T, ParserError> {
        guard let asset = NSDataAsset(name: fileName) else {
            return .failure(.assetNotfound)
        }
        guard let decodeData = try? jsonDecoder.decode(decodingType, from: asset.data) else {
            return .failure(.decodingFail)
        }
        return .success(decodeData)
    }
    
    func decode<T: Decodable>(source: Data, decodingType: T.Type) -> Result<T, ParserError> {
        guard let data = try? jsonDecoder.decode(decodingType, from: source) else {
            return .failure(.decodingFail)
        }
        return .success(data)
    }
    
    func encode<T: Encodable>(object: T) -> Result<Data, ParserError> {
        guard let data = try? jsonEncoder.encode(object) else {
            return .failure(.encodingFail)
        }
        return .success(data)
    }
}
