//
//  Decodable+Extension.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/10.
//

import UIKit

protocol Catalog: Decodable {
    func parse(name: String) -> Self?
}

extension Catalog {
    func parse(name: String) -> Self? {
        guard let asset = NSDataAsset(name: name) else {
            return nil
        }
        
        let jsonData = asset.data
        let product = try? JSONDecoder().decode(Self.self, from: jsonData)
        return product
    }
}
