//
//  JSONDecoder+.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import UIKit

extension JSONDecoder {
    static func decode<T: Decodable>(_ type: T.Type, from asset: String) -> T? {
        let decoder: JSONDecoder = JSONDecoder()
        guard let asset: NSDataAsset = NSDataAsset(name: asset) else {
            return nil
        }
        
        do {
            return try decoder.decode(type, from: asset.data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
