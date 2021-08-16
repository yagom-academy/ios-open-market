//
//  JsonHandler.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/11.
//

import Foundation

enum DecodeError: Error {
    case decodeFail
    case notFound
}

struct JsonHandler {
    func decodeJSONData<T: Decodable>(json: Data?, model: T.Type) throws -> T {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = json else { throw DecodeError.notFound }
        do {
            return try jsonDecoder.decode(model, from: data)
        } catch {
            throw DecodeError.decodeFail
        }
    }
}
