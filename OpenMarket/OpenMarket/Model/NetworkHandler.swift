//
//  URLSeesion.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/10.
//

import Foundation

enum HttpMethod {
    case get
    case post
    case delete
    case patch
    
    var string: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        }
    }
}

struct NetworkHandler {
    private let session: URLSessionProtocol
    private let baseURL = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func communicate(pathString: String, httpMethod: HttpMethod, completionHandler: @escaping (Result<Data?, APIError>) -> Void) {
        guard let url = URL(string: baseURL + pathString) else {
            return completionHandler(.failure(.convertError))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.string
        
        session.receiveResponse(request: request) { responseResult in
            guard responseResult.error == nil else {
                return completionHandler(.failure(.transportError))
            }
            
            guard let response = responseResult.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completionHandler(.failure(.responseError))
            }
            
            switch httpMethod {
            case .get:
                completionHandler(.success(responseResult.data))
            case .post:
                completionHandler(.success(responseResult.data))
            case .delete:
                completionHandler(.success(responseResult.data))
            case .patch:
                completionHandler(.success(responseResult.data))
            }
        }
    }
}
