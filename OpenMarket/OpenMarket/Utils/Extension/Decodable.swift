//
//  Decodable.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/06/01.
//

import Foundation

extension Decodable {
    
    static func parse(data: Data) -> Self? {
        Json.decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let product = try? Json.decoder.decode(Self.self, from: data) else {
            return nil
        }
        
        return product
    }
}
