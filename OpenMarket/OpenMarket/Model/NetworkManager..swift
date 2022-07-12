//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import Foundation

class NetworkManager {
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }

    func fetch<T: Decodable>(dataType: T.Type, request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {

        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data,
                let response = response as? HTTPURLResponse,
               (200...299).contains(response.statusCode){
                do {
                    let data = try JSONDecoder().decode(dataType, from: data)
                } catch {
                    completion(.failure(error))
                }
            }
        }).resume()
    }
}
