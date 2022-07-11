//
//  JSONDecorder + Extension.swift
//  OpenMarket
//
//  Created by Kiwon Song on 2022/07/11.
//

import Foundation

extension JSONDecoder {
    static func decodeJson<T: Codable>(jsonName: String) -> T? {
        let decoder = JSONDecoder()
        
        guard let fileLocation = Bundle.main.url(forResource: jsonName, withExtension: "json") else { return nil }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let itemInfo =  try decoder.decode(T.self, from: data)
            return itemInfo
        } catch {
            print(error)
            return nil
        }
    }
}
