//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//

import Foundation
import UIKit

class NetworkManger {
    
    let session: MockURLSessionProtocol
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getData(completion: @escaping (Result<ItemPage, Error>) -> Void) {
        
        let request = URLRequest(url: Network.firstPage.url)
        
        let task: URLSessionDataTask = session
            .dataTask(with: request) { data, urlResponse, error in
                guard let response = urlResponse as? HTTPURLResponse,
                      (200...399).contains(response.statusCode) else {
                    completion(.failure(error ?? APIError.unknownError))
                    return
                }
                
                if let data = data {
                    guard let decodingData = try? JSONDecoder().decode(ItemPage.self, from: data) else {
                        completion(.failure(APIError.unknownError))
                        return
                    }
                    completion(.success(decodingData))
                }
            }
        task.resume()
    }
}
