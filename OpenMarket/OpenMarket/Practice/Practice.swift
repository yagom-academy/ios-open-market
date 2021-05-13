//
//  Practice.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/11.
//

import UIKit

struct Person: Codable {
    let name: String
    let age: Int
    let gender: Bool
}

struct JSONPersonData {
    var personData: [Person] = []
    
    mutating func parseJSONData(assetName: String) {
        let decoder = JSONDecoder()
        
        guard let dataAsset = NSDataAsset(name: assetName) else { return }
        guard let personData = try? decoder.decode([Person].self, from: dataAsset.data) else { return }
        self.personData = personData
    }
}
