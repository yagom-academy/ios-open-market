//
//  request.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/03.
//

import UIKit

enum NetworkError: Error {
  case statusCodeError
  case receiveDataFailed
  case connectFailed
}

extension URLSession {  
  func dataTask(
    _ request: URLRequest,
    completion: @escaping (Result<Data, NetworkError>) -> Void
  ) -> URLSessionDataTask {
    let dataTask = dataTask(with: request) { data, response, error in
      guard error == nil else {
        return completion(.failure(.connectFailed))
      }
      guard let data = data else {
        return completion(.failure(.receiveDataFailed))
      }
      guard let response = response as? HTTPURLResponse,
        (200..<300) ~= response.statusCode else {
          return completion(.failure(.statusCodeError))
      }
      return completion(.success(data))
    }
    return dataTask
  }
  
}
