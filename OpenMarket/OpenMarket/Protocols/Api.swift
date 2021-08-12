//
//  API.swift
//  OpenMarket
//
//  Created by jost, 잼킹 on 2021/08/10.
//

import Foundation

enum ApiError: LocalizedError {
    case invalidUrl
    case invalideData
    case dataTask
    case invalidResponse
    case unknown
    case outOfRange(statusCode: Int)
    case serverMessage(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .invalideData:
            return "Invalid Data"
        case .dataTask:
            return "DataTask Error"
        case .invalidResponse:
            return "Invalid Response"
        case .unknown:
            return "Api Unknown Error"
        case .outOfRange(let statusCode):
            return "status: \(statusCode)"
        case .serverMessage(let message):
            return message
        }
    }
}

protocol Api {
    func getMarketPageItems(for pageNumber: Int, completion: @escaping (Result<MarketItems, Error>) -> Void)
    func getMarketItem(for id: Int, completion: @escaping (Result<MarketItem, Error>) -> Void)
}
