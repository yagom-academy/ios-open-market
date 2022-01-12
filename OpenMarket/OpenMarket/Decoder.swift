//
//  Decoder.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/07.
//

import UIKit


struct Decoder {
    let decoder = JSONDecoder()

    func parsePageJSON() throws -> ProductList {
        guard let pageJSON: NSDataAsset = NSDataAsset(name: "products") else {
            throw NetworkError.parsingFailed
        }
        
        guard let decodedPageJSON = try decoder.decode(ProductList?.self, from: pageJSON.data) else {
            throw NetworkError.parsingFailed
        }
        
        return decodedPageJSON
    }
}
