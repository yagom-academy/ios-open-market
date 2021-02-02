//
//  OenMarketAPI.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

enum OpenMarketAPIError: Error {
    case dataDecodingError
    case clientSideError
    case serverSideError
    case noData
    case noResponse
    case wrongURL
    case unknown
}

class OpenMarketAPI {
    
    private static var session = URLSession(configuration: .default)
    
    private static func sendRequest(_ request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { (data, response, error) in
            let result = Network.getResult(data: data, response: response, error: error)
            completionHandler(result)
        }.resume()
    }
    
    static func request<T: Decodable>(_ type: RequestType, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let request = type.urlRequest() else {
            return
        }
        self.sendRequest(request) { result in
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
