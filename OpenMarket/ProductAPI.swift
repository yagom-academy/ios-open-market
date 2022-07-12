//
//  ProductAPI.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/11.
//

import UIKit

struct ProductAPI {
    private let session: URLSessionProtocol

    init(_ session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ fileName: String, for type: T.Type) -> Result<T, APIError> {
        let jsonDecoder = JSONDecoder()

        do {
            guard let asset = NSDataAsset.init(name: fileName) else {
                return .failure(.jsonFileNotFound)
            }

            let result = try jsonDecoder.decode(T.self, from: asset.data)
            return .success(result)
        } catch {
            return .failure(.failedToDecode)
        }
    }

    func call<T: Decodable>(_ urlString: String, for type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let requestURL = URLRequest(url: url)

        let task = self.session.dataTask(with: requestURL) { (data, response, error) in

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
