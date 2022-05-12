//
//  DataDecoder.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/12.
//

import Foundation

enum DataDecoder {
    static func decodeHealthCheck(data: Result<Data, APIError>) throws -> String {
        switch data {
        case .success(let data):
            let health = String(decoding: data, as: UTF8.self)
            return health.trimmingCharacters(in: ["\""])
        case .failure(let error):
            throw error
        }
    }
    
    static func decodeItemPage(data: Result<Data, APIError>) throws -> ItemPage {
        switch data {
        case .success(let data):
            do {
                let itemPage = try JSONDecoder().decode(ItemPage.self, from: data)
                return itemPage
            } catch {
                throw APIError.decodeError
            }
        case .failure(let error):
            throw error
        }
    }
    
    static func decodeItemDetail(data: Result<Data, APIError>) throws -> ItemDetail {
        switch data {
        case .success(let data):
            do {
                let itemDetail = try JSONDecoder().decode(ItemDetail.self, from: data)
                return itemDetail
            } catch {
                throw APIError.decodeError
            }
        case .failure(let error):
            throw error
        }
    }
}
