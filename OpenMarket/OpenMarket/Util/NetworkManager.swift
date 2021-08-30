//
//  ItemAPIProvider.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/11.
//

import Foundation

struct NetworkManager {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    // TODO: - URL의 형식에 따라 타입을 결정해주는 로직
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task: URLSessionDataTaskProtocol = session
            .dataTaskWithRequest(with: request) { responseData, urlResponse, responseError in
                do {
                    let data = try obtainResponseData(data: responseData,
                                                  response: urlResponse,
                                                  error: responseError)
                    
                    let parsedResult = data.parse(type: T.self)
                    
                    switch parsedResult {
                    case .success(let decodedData):
                        completion(.success(decodedData))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            }
        task.resume()
    }
    
    private func obtainResponseData(data: Data?, response: URLResponse?, error: Error?) throws -> Data {
        if let error = error {
            throw error
        }
        
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        guard let data = data else {
            throw NetworkError.dataNotFound
        }
        
        return data
    }
}
