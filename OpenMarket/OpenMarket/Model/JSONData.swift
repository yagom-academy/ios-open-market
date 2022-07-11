//
//  JSONData.swift
//  OpenMarket
//
//  Created by 케이, 수꿍 on 2022/07/11.
//

import Foundation

struct JSONData {
    static func parse(_ fileName: String, _ fileExtension: String) -> Market? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            return nil
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            return nil
        }
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        guard let data = data,
            let market = try? decoder.decode(Market.self, from: data) else {
            return nil
        }
        return market
    }
}
