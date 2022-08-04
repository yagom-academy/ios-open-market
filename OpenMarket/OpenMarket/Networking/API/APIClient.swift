//
//  NetworkProvider.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

struct APIClient {
    private var session: URLSession
    static let shared = APIClient(session: URLSession.shared)
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func requestData(with url: URL,
                     completion: @escaping (Result<Data,APIError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
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
            
            completion(.success(verifiedData))
        }.resume()
        
    }
    
    func requestData(with urlRequest: URLRequest,
                     completion: @escaping (Result<Data,APIError>) -> Void) {
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
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
            
            completion(.success(verifiedData))
        }.resume()
    }
}
