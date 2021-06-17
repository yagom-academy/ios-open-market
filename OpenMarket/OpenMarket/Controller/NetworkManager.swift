//
//  URLSessionManager.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/05/28.
//

import Foundation
class NetworkManager<T: Decodable> {
    let clientRequest: URLRequest
    let session: URLSessionProtocol

    init(clientRequest: URLRequest, session: URLSessionProtocol){
        self.clientRequest = clientRequest
        self.session = session
    }

    func getServerData(url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: url){ data, response, error in
            guard error == nil else {
                completionHandler(.failure(.receiveError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.receiveUnwantedResponse))
                return
            }

            if let data = data {
                guard let convertedData = try? JSONDecoder().decode(T.self, from: data) else {
                    completionHandler(.failure(.receiveUnwantedResponse))
                    return
                }
                completionHandler(.success(convertedData))
            }
        }.resume()
    }
}
