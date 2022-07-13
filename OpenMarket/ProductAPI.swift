//
//  ProductAPI.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/11.
//

import UIKit

struct ProductAPI {
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func call<T: Decodable>(_ urlString: String, for type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        dataTask(url: url, completion: completion)
    }

    private func dataTask<T: Decodable>(url: URL, completion: @escaping (Result<T, APIError>) -> Void) {
        let task = session.dataTask(with: url) { (data, response, error) in

            guard let response = response as? HTTPURLResponse,
                  (200...299) ~= response.statusCode else {
                completion(.failure(.networkConnectionIsBad))
                return
            }

            if error != nil {
                completion(.failure(.unknownErrorOccured))
                return
            }

            guard let data = data,
                  let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.failedToDecode))
                return
            }

            completion(.success(decodedData))
        }

        task.resume()
    }
}
