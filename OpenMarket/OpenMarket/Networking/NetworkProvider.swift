//
//  NetworkProvider.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍. 
//

import Foundation

class NetworkProvider {
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func requestAndDecode<T: Codable>(url: URL,
                                      dataType: T.Type,
                                      completion: @escaping (Result<T,NetworkError>) -> Void) {
        let dataTask: URLSessionDataTaskProtocol = session.dataTask(with: url) { data, response, error in
            
            if error != nil {
                completion(.failure(.unknownErrorOccured))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completion(.failure(.invalidURL))
                return
            }
         
            guard let verifiedData = data else {
                completion(.failure(.emptyData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self,
                                                           from: verifiedData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.failedToDecode))
            }
        }
        dataTask.resume()
    }
}
