//
//  Parser.swift
//  OpenMarket
//
//  Created by 박세웅 on 2022/05/09.
//

import UIKit

struct Parser<T: Codable> {
    static func decode(name: String) -> T? {
        let decoder = JSONDecoder()
        guard let asset = NSDataAsset(name: name, bundle: .main) else {
            return nil
        }
        guard let listData = try? decoder.decode(T.self, from: asset.data) else {
            return nil
        }
        
        return listData
    }
}
