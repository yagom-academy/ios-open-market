//
//  Decoder.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/07.
//

import Foundation

struct Decoder {
    func parseJSON (data: Data) -> ProductList? {
        do {
            let decoder = JSONDecoder()
            
            let pageJSON: Data = data
            let decodedPageJSON = try decoder.decode(ProductList.self, from: pageJSON)
            return decodedPageJSON
        } catch {
            return nil
        }
    }
}
