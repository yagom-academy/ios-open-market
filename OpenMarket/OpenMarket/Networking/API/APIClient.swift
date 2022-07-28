//
//  NetworkProvider.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
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
            
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(.unknownErrorOccured))
                }
                
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidURL))
                }
                
                return
            }
            
            guard let verifiedData = data else {
                DispatchQueue.main.async {
                    completion(.failure(.emptyData))
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(verifiedData))
            }
        }.resume()
        
    }
    
    func requestData(with urlRequest: URLRequest,
                     completion: @escaping (Result<Data,APIError>) -> Void) {
        session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(.unknownErrorOccured))
                }
                
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidURL))
                }
                
                return
            }
            
            guard let verifiedData = data else {
                DispatchQueue.main.async {
                    completion(.failure(.emptyData))
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(verifiedData))
            }
        }.resume()
    }
}
