//
//  DecodeManager.swift
//  OpenMarket
//
//  Created by jin on 11/15/22.
//
import UIKit

class DecodeManger {
    static let shared = DecodeManger()
    let decoder = JSONDecoder()
    
    private init() { }

    func fetchData<T: Decodable>(name: String) throws -> T? {
                
        guard let assetData = NSDataAsset.init(name: name) else { throw DataError.noneDataError }
        
        guard let itemData = try? decoder.decode(T.self, from: assetData.data) else {
            throw DataError.decodingError
        }
        
        return itemData
    }
}
