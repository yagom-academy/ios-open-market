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
  
  func dataTaskForString(
    _ request: URLRequest,
    completion: @escaping (Result<String, NetworkError>) -> Void
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
      let json = JSONParser()
      let string: Result<String, ResponseError> = json.decode(data: data, type: String.self)
      switch string {
      case .success(let data):
        completion(.success(data))
      case .failure(let error):
        print(error)
      }
      //return completion(.success(data))
    }
    return dataTask
  }
}
