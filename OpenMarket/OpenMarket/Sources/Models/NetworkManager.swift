//
//  DataManager.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/14.
//

import UIKit

struct NetworkManager {
    
    // MARK: - Static Actions
    
    static func performRequestToAPI(from hostAPI: String, with request: String,
                                    completion: @escaping (Result<Data, NetworkingError>) -> Void) {
        let url = hostAPI + request
        
        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                return completion(.failure(.clientTransport))
            }
            
            guard isValidResponse(response) else {
                return completion(.failure(.serverSideInvalidResponse))
            }
            
            guard let data = data else {
                return completion(.failure(.missingData))
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    static func makeDataFrom(fileName: String) -> Data? {
        guard let dataAsset: NSDataAsset = NSDataAsset.init(name: fileName) else {
            return nil
        }
        
        return dataAsset.data
    }
    
    static func parse<T: Decodable>(_ data: Data,
                                    into type: T.Type) -> T? {
        let jsonDecoder: JSONDecoder = JSONDecoder()
                
        do {
            let decodedData = try jsonDecoder.decode(T.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}

// MARK: - Private Static Actions

private extension NetworkManager {
    static func isValidResponse(_ response: URLResponse?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            return false
        }
        
        return true
    }
}
