//
//  NetworkModule.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/17.
//

import Foundation

struct NetworkModule: DataTaskRequestable {
    func runDataTask(using request: URLRequest, with completionHandler: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
               OpenMarketAPIConstants.rangeOfSuccessState.contains(response.statusCode),
               let data = data {
                DispatchQueue.main.async {
                    completionHandler(.success(data))
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.unknown))
                }
            }
        }.resume()
    }
}
