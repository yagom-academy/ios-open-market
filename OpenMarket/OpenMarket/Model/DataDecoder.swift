//
//  DataDecoder.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/12.
//

import Foundation

enum DataDecoder {
    static func healthCheck(data: Result<Data, APIError>) throws -> String {
        switch data {
        case .success(let data):
            let health = String(decoding: data, as: UTF8.self)
            return health.trimmingCharacters(in: ["\""])
        case .failure(let error):
            throw error
        }
    }
}
