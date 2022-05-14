//
//  Decodable+Extension.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/14.
//

import Foundation

extension Decodable {
    static func parse(data: Data) -> Self? {
        let json = JSONDecoder()
        json.keyDecodingStrategy = .convertFromSnakeCase
        guard let product = try? json.decode(Self.self, from: data) else {
            return nil
        }
        return product
    }
}
