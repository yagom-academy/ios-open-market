//
//  Parsable.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/05.
//

import Foundation

protocol Parsable {
    func parse<T: Decodable>(with data: Data) -> T?
}

extension Parsable {
    func parse<T: Decodable>(with data: Data) -> T? {
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            return data
        } catch {
            return nil
        }
    }
}
