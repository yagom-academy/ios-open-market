//
//  ParsingManager.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/03.
//

import Foundation

struct ParsingManager {
    enum ParsingError: Error {
        case decodingFailed
    }
    
    private let decoder = JSONDecoder()
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func parse<T: Decodable>(_ data: Data, to model: T.Type) -> Result<T, ParsingError> {
        let parsedData = try? decoder.decode(model, from: data)
        guard let jsonData = parsedData else {
            return .failure(.decodingFailed)
        }
        return .success(jsonData)
    }
}
