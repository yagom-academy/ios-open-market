//
//  DataManager.swift
//  OpenMarket
//
//  Created by minsson on 2022/07/14.
//

import UIKit

struct DataManager {
    static func parse<T: Decodable>(_ fileName: String, into target: T) -> T? {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        let targetType = type(of: target)
        
        guard let dataAsset: NSDataAsset = NSDataAsset.init(name: fileName) else {
            return nil
        }

        do {
            let data = try jsonDecoder.decode(targetType.self, from: dataAsset.data)
            return data
        } catch {
            return nil
        }
    }
}


