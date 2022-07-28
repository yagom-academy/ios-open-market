//
//  JSONDecoder+extension.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/28.
//

import Foundation

extension JSONDecoder {
    static func decodeJson<T: Codable>(jsonData: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let itemInfo =  try decoder.decode(T.self, from: jsonData)
            return itemInfo
        } catch {
            print(error)
            return nil
        }
    }
}
