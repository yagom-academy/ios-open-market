//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/01.
//

import Foundation

class NetworkManager {
    private let request = Request()
    private let session: URLSessionProtocol
    private var valuableHTTPMethod: [APIHTTPMethod]
    private static let rangeOfSuccessState = 200...299
    
    init(session: URLSessionProtocol = URLSession.shared,
         valuableHTTPMethod: [APIHTTPMethod] = APIHTTPMethod.allCases) {
        self.session = session
        self.valuableHTTPMethod = valuableHTTPMethod
    }
    
    func commuteWithAPI(api: Requestable, completionHandler: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let request = try? request.createRequest(url: api.url, api: api) else {
            completionHandler(.failure(.requestFailed))
            return
        }
        guard valuableHTTPMethod.contains(api.httpMethod) else {
            completionHandler(.failure(.invalidHttpMethod))
            return
        }
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.dataTaskError))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (Self.rangeOfSuccessState).contains(response.statusCode) else {
                completionHandler(.failure(.responseFailed))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.dataNotfound))
                return
            }
            completionHandler(.success(data))
        }.resume()
    }
}
