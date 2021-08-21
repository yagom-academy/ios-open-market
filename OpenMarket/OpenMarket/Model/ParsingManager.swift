//
//  ParsingManager.swift
//  OpenMarket
//
//  Created by Kim Do hyung on 2021/08/13.
//

import Foundation

enum JsonError: Error {
    case decodingError
    case encodingError
}

struct ParsingManager {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func decodingData<T:Decodable>(data: Data, model: T.Type) -> T? {
        let convertedModel = try? decoder.decode(T.self, from: data)
        return convertedModel
    }
    
    func encodingModel(model: [String: String?]?) -> Data? {
        let convertedData = try? encoder.encode(model)
        return convertedData
    }
}
