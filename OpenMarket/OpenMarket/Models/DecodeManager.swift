//
//  DecodeManager.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/14.
//

import UIKit

struct DecodeManager<T: Decodable> {
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchData(name: String) throws -> Result<T, DataError> {
        guard let assetData: NSDataAsset = NSDataAsset.init(name: name) else {
            return Result.failure(DataError.empty)
        }
        
        guard let datas = try? decoder.decode(T.self, from: assetData.data) else {
            return Result.failure(DataError.decoding)
        }
        
        return Result.success(datas)
    }
}
