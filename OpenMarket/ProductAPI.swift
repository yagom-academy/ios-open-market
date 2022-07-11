//
//  ProductAPI.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/11.
//

import UIKit

struct ProductAPI {
    func fetch<T: Decodable>(_ fileName: String, for type: T.Type) -> Result<T, APIError> {
        let jsonDecoder = JSONDecoder()

        do {
            guard let asset = NSDataAsset.init(name: fileName) else {
                return .failure(APIError.jsonFileNotFound)
            }

            let result = try jsonDecoder.decode(T.self, from: asset.data)
            return .success(result)
        } catch {
            return .failure(APIError.failedToDecode)
        }
    }

    func call<T: Decodable>(_ urlString: String, for type: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.failedToDecode))
            return
        }

        let requestURL = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: requestURL) { (data, _, _) in
            guard let data = data,
                  let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(APIError.failedToDecode))
                return
            }

            completion(.success(decodedData))
        }

        task.resume()
    }
}
