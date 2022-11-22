//
//  OpenMarket - NetworkManager.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

import Foundation

struct NetworkManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    private func dataTask<T: Decodable>(request: URLRequest,
                          dataType: T.Type,
                          completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.dataTaskError))
            }
            
            if let serverResponse = response as? HTTPURLResponse {
                switch serverResponse.statusCode {
                case 100...101:
                    return completion(.failure(.informational))
                case 200...206:
                    break
                case 300...307:
                    return completion(.failure(.redirection))
                case 400...415:
                    return completion(.failure(.clientError))
                case 500...505:
                    return completion(.failure(.serverError))
                default:
                    return completion(.failure(.unknownError))
                }
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            let decodedData = JSONDecoder.decodeData(data: data, to: dataType.self)
            
            if let data = decodedData {
                return completion(.success(data))
            } else {
                return completion(.failure(.parsingError))
            }
        }
        
        task.resume()
    }
}

extension NetworkManager: NetworkRequestable {
    func request<T: Decodable>(from url: URL?,
                 httpMethod: HttpMethod,
                 dataType: T.Type,
                 completion: @escaping (Result<T,NetworkError>) -> Void) {
        if let targetURL = url {
            var request: URLRequest = URLRequest(url: targetURL,timeoutInterval: Double.infinity)
            request.httpMethod = httpMethod.name
            
            dataTask(request: request, dataType: dataType, completion: completion)
        }
    }
}
