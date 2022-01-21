//
//  URLSession+Extension.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import Foundation

enum URLSessionError: Error {
  case networkError
  case statusCodeError
}

extension URLSession {
  func dataTask(request: URLRequest, completion: @escaping (Result<Data, URLSessionError>) -> Void)
  -> URLSessionDataTask {
    let dataTask = self.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      guard error == nil else {
        completion(.failure(.networkError))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
      else {
        completion(.failure(.statusCodeError))
        return
      }
      
      guard let receivedData = data else {
        return
      }
      completion(.success(receivedData))
    }
    return dataTask
  }
}
