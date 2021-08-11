//
//  ItemAPIProvider.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/11.
//

import Foundation

class ItemAPIProvider {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task: URLSessionDataTask = session
            .dataTask(with: request) { data, urlResponse, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let response = urlResponse as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    completion(.failure(error ?? APIError.unknownError))
                    return
                }
                
                if let data = data,
                   let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(decodedData))
                    return
                }
                completion(.failure(APIError.unknownError))
        }
        task.resume()
    }
}
