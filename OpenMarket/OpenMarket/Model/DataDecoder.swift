//
//  DataDecoder.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/12.
//

import Foundation

enum DataDecoder {
    static func decode<T: Codable>(data: Result<Data, APIError>, dataType: T.Type) throws -> T {
        switch data {
        case .success(let data):
            do {
                let decodedData = try JSONDecoder().decode(dataType, from: data)
                return decodedData
            } catch {
                throw APIError.decodeError
            }
        case .failure(let error):
            throw error
        }
    }
}
