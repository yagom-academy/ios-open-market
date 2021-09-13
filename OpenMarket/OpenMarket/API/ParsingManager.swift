//
//  ParsingManager.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/13.
//

import UIKit

enum ParsingError: Error {
    case parsingFailed
}

struct ParsingManager {
    let decoder = JSONDecoder()

    func decode<T: Codable>(_ data: Data, to modelType: T.Type) throws -> T {
        do {
            let resultData = try decoder.decode(modelType, from: data)
            return resultData
        } catch {
            throw ParsingError.parsingFailed
        }
    }
}
