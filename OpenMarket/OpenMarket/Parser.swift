//
//  Parser.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/03.
//

import UIKit

struct Parser {
    private let jsonDecoder = JSONDecoder()
    
    func decode<T: Decodable>(fileName: String, decodingType: T.Type) -> Result<T, ParserError> {
        guard let asset = NSDataAsset(name: fileName) else {
            return .failure(.assestNotfound)
        }
        guard let decodeData = try? jsonDecoder.decode(decodingType, from: asset.data) else {
            return .failure(.decodingError)
        }
        return .success(decodeData)
    }
    
    func decode<T: Decodable>(source: Data, decodingType: T.Type) -> Result<T, ParserError> {
        guard let data = try? jsonDecoder.decode(decodingType, from: source) else {
            return .failure(.decodingError)
        }
        return .success(data)
    }
}
