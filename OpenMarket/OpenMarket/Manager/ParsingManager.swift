//
//  ParsingManager.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/10.
//

import UIKit

struct ParsingManager {
    private let jsonDecoder = JSONDecoder()
    
    func decode<T: Decodable>(from source: Data, to destinationType: T.Type) throws -> T {
        return try jsonDecoder.decode(destinationType, from: source)
    }
    
    func decode<T: Decodable>(from fileName: String, to destinationType: T.Type) throws -> T {
        guard let asset = NSDataAsset(name: fileName) else {
            throw NSError()
        }
        return try jsonDecoder.decode(destinationType, from: asset.data)
    }
}
