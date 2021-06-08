//
//  URLSessionManager.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation
class NetworkManager<T: Decodable> {
    let clientRequest: GETRequest
    let session: URLSessionProtocol

    init(clientRequest: GETRequest, session: URLSessionProtocol){
        self.clientRequest = clientRequest
        self.session = session
    }
    
    func getServerData(url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: url){ data, response, error in
            if error != nil {
                return completionHandler(.failure(.receiveError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(.receiveUnwantedResponse))
            }
            
            if let data = data {
                guard let convertedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print(1)
                    return completionHandler(.failure(.receiveUnwantedResponse))
                }
                print(2)
                return completionHandler(.success(convertedData))
            }
        }.resume()
    }
}
