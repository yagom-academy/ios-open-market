//
//  Parsable.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/05.
//

import Foundation

protocol Parsable {
    func parse<T: Decodable>(with data: Data, type: T.Type) throws -> T
}

extension Parsable {
    func parse<T: Decodable>(with data: Data, type: T.Type) throws -> T {
        do {
            let data = try JSONDecoder().decode(type, from: data)
            return data
        } catch {
            throw JSONError.parsingError
        }
    }
}
