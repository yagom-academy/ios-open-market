//
//  Decodable+Extension.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/10.
//

import UIKit

struct ParseManager<T: Decodable> {
    static func parse(name: String) -> T? {
        guard let asset = NSDataAsset(name: name) else {
            return nil
        }
        
        let jsonData = asset.data
        let product = try? JSONDecoder().decode(T.self, from: jsonData)
        return product
    }
}
