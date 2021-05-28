//
//  JSONParser.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/13.
//

import UIKit

struct JSONParser<T: Codable> {
    var convertedData: T?
    
    mutating func parse(assetName: String) {
        let decoder = JSONDecoder()
        
        guard let assetData = NSDataAsset(name: assetName) else { return }
        guard let convertedData = try? decoder.decode(T.self, from: assetData.data) else { return }
        self.convertedData = convertedData
    }
}
