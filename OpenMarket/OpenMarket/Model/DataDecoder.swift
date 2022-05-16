//
//  DataDecoder.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/12.
//

import Foundation

enum DataDecoder {
    static func decode<T: Codable>(data: Data?, dataType: T.Type) throws -> T {
        guard let data = data else {
            throw APIError.dataError
        }
        do {
            let decodedData = try JSONDecoder().decode(dataType, from: data)
            return decodedData
        } catch {
            throw APIError.decodeError
        }
    }
}
