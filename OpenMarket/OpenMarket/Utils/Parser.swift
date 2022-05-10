//
//  Parser.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/09.
//

import UIKit

struct Parser<T: Codable> {
    func decode(name: String) -> T? {
        let decoder = JSONDecoder()
        guard let asset = NSDataAsset(name: name, bundle: .main) else {
            return nil
        }
        guard let decodedData = try? decoder.decode(T.self, from: asset.data) else {
            return nil
        }
        
        return decodedData
    }
}
