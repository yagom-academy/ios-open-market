//
//  Parser.swift
//  OpenMarket
//
//  Created by marisol on 2022/05/09.
//

import UIKit

struct Parser {
    func decode() throws -> [Products] {
        let jsonDecoder = JSONDecoder()
        
        guard let productData = NSDataAsset(name: "products") else {
            throw DecodingError.notFoundFile
        }
        
        guard let products = try? jsonDecoder.decode([Products].self, from: productData.data) else {
            throw DecodingError.failedDecoding
        }
        
        return products
    }
}
