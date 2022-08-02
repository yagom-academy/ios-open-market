//
//  GETProtocol.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/08/02.
//

import Foundation

protocol GETProtocol: APIProtocol { }

extension GETProtocol {
    func requestAndDecodeProduct<T: Decodable>(using client: APIClient = APIClient.shared,
                                    dataType: T.Type,
                                    completion: @escaping (Result<T,APIError>) -> Void) {
        
        var request = URLRequest(url: configuration.url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        client.requestData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self,
                                                               from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.failedToDecode))
                }
                
                return
            case .failure(_):
                completion(.failure(.emptyData))
                
                return
            }
        }
    }
}
