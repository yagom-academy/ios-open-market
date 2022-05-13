//
//  URLSeesion.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/10.
//

import Foundation

struct NetworkHandler {
    private let session: URLSessionProtocol
    private let baseURL = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func getData(pathString: String, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: baseURL + pathString) else {
            return completionHandler(.failure(.convertError))
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(.transportError))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.dataError))
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completionHandler(.failure(.responseError))
            }
            
            completionHandler(.success(data))
        }
        
        dataTask.resume()
    }
}
