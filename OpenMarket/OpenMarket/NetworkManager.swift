//
//  ItemAPIProvider.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/11.
//

import Foundation

struct NetworkManager {
    let session: URLSessionProtocol
    let parser: JSONParser
    
    init(session: URLSessionProtocol, parser: JSONParser) {
        self.session = session
        self.parser = parser
    }
    
    // TODO: - URL의 형식에 따라 타입을 결정해주는 로직
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task: URLSessionDataTaskProtocol = session
            .dataTaskWithRequest(with: request) { data, urlResponse, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let response = urlResponse as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.dataNotFound))
                    return
                }
                
                let parsedResult = self.parser.parse(type: T.self, data: data)
                
                switch parsedResult {
                case .success(let decodedData):
                    completion(.success(decodedData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        task.resume()
    }
}
