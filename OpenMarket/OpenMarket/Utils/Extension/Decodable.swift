//
//  Decodable+Extension.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/14.
//

import Foundation

struct Json {
static let decoder = JSONDecoder()
    private init() {}
}

extension Decodable {
    static func parse(data: Data) -> Self? {
        Json.decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let product = try? Json.decoder.decode(Self.self, from: data) else {
            return nil
        }
        
        return product
    }
}
