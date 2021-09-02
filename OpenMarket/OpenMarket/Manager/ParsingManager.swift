//
//  JsonManager.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import UIKit

struct ParsingManager {
    private let jsonDecoder = JSONDecoder()
    
    func loadedDataAsset(assetName: String) throws -> NSDataAsset {
        guard let dataAsset = NSDataAsset(name: assetName) else {
            throw ParsingError.loadAssetFailed
        }
        return dataAsset
    }
    
    func decodedJSONData<T: Decodable>(type: T.Type, data: Data) throws -> T {
        guard let decodedData = try? jsonDecoder.decode(type, from: data) else {
            throw ParsingError.decodingFailed
        }
        return decodedData
    }
}
