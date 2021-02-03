//
//  OenMarketAPI.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

enum OpenMarketAPIError: Error {
    case dataDecodingError
    case redirectionMessage
    case clientSideErrorResponse
    case serverSideErrorResponse
    case noData
    case noResponse
    case wrongURL
    case unknown
}

struct OpenMarketAPI {    
    static func request<T: Decodable>(_ type: RequestType, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let request = type.urlRequest else {
            return
        }
        Network.sendRequest(request) { result in
            switch result {
            case .success(let data):
                guard let decodedData = Parser.decodeData(T.self, data) else {
                    completionHandler(.failure(OpenMarketAPIError.dataDecodingError))
                    return
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
