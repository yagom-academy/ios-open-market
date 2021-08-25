//
//  NetworkingManager.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/08/20.
//

import Foundation

struct NetworkingManager {
    private enum NetworkingManagerError: Error {
        case failMakingURL
        case failRequestByError
        case failRequestByResponse
        case failRequestByData
    }
    
    enum OpenMarketInfo {
        case getList
        case getItem
        case postItem
        case patchItem
        case deleteItem
        
        static let baseURL = "https://camp-open-market-2.herokuapp.com"
        var prefix: String {
            switch self {
            case .getList:
                return "items"
            default:
                return "item"
            }
        }
        
        func makePath(suffix: Int? = nil) -> String {
            if let unwrappedSuffix = suffix {
                return "/\(self.prefix)/\(unwrappedSuffix)"
            } else {
                return "/\(self.prefix)"
            }
        }
    }
    
    private let session: URLSessionProtocol
    private let parsingManager: ParsingManager

    init(session: URLSessionProtocol, parsingManager: ParsingManager) {
        self.session = session
        self.parsingManager = parsingManager
    }
    
    func configureRequest(from api: RequestAPI) throws -> URLRequest {
        guard let url = URL(string: OpenMarketInfo.baseURL + api.path) else {
            throw NetworkingManagerError.failMakingURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = api.method.description
        request.httpBody = api.body
        
        return request
    }
    
    func request(bundle request: URLRequest, completion: @escaping (Result<Data, Error>) -> ()) {
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkingManagerError.failRequestByError))
                return
            }
            guard let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode) else {
                completion(.failure(NetworkingManagerError.failRequestByResponse))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkingManagerError.failRequestByData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}

