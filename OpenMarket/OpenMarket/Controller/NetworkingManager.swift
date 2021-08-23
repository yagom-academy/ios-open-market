//
//  NetworkingManager.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/08/20.
//

import Foundation

struct NetworkingManager {
    enum NetworkingManagerError: Error {
        case failMakingURL
        case failRequestByError
        case failRequestByResponse
        case failRequestByData
    }
    
    let session: URLSessionProtocol
    let parsingManager: ParsingManager
    let baseURL: String
    
    init(session: URLSessionProtocol, parsingManager: ParsingManager, baseURL: String) {
        self.session = session
        self.parsingManager = parsingManager
        self.baseURL = baseURL
    }
    
    func configureRequest(from api: RequestAPI) throws -> URLRequest {
        guard let url = URL(string: baseURL + api.path) else {
            throw NetworkingManagerError.failMakingURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = api.method.description
        request.httpBody = api.body
        
        return request
    }
    
    func request(bundle request: URLRequest, completion: @escaping (Result<ResultArgument, Error>) -> ()) {
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
            let parsedData = parsingManager.parse(data, to: ItemBundle.self)
            switch parsedData {
            case .success(let data):
                completion(.success(data as ResultArgument))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}

