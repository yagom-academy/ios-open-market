//
//  Parser.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/09.
//

import UIKit

struct Parser<T: Decodable> {
    func decode() throws -> T {
        let jsonDecoder = JSONDecoder()
        
        guard let productData = NSDataAsset(name: "products") else {
            throw DecodingError.notFoundFile
        }
        
        guard let products = try? jsonDecoder.decode(T.self, from: productData.data) else {
            throw DecodingError.failedDecoding
        }
        
        return products
    }
}
