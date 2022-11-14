//
//  DecodeManager.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/14.
//

import UIKit

struct DecodeManager {
    private let decoder: JSONDecoder = JSONDecoder()
    
    func fetchData(name: String) throws -> [Product] {
        guard let assetData: NSDataAsset = NSDataAsset.init(name: name) else {
            throw DataError.empty
        }
        guard let datas = try? decoder.decode([Product].self, from: assetData.data) else {
            throw DataError.decoding
        }
        
        return datas
    }
}
