//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

struct URLSessionProvider<T: Decodable> {
  private let hostApi = "https://market-training.yagom-academy.kr"
  private let session: URLSessionProtocol
  private let path: String
  private let parameters: [String: String]
  
  init(session: URLSessionProtocol = URLSession.shared,
       path: String = "",
       parameters: [String: String] = [:])
  {
    self.session = session
    self.path = path
    self.parameters = parameters
  }
  
  func get(completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
    guard var urlComponents = URLComponents(string: hostApi + path) else {
      return
    }
    let query = parameters.map {
      URLQueryItem(name: $0.key, value: $0.value)
    }
    urlComponents.queryItems = query
    guard let url = urlComponents.url else {
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    session.dataTask(with: request) { data, response, error in
      guard error == nil else {
        completionHandler(.failure(.invalid))
        return
      }
      guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode)
      else {
        completionHandler(.failure(.statusCodeError))
        return
      }
      guard let data = data else {
        completionHandler(.failure(.invalid))
        return
      }
      guard let products = try? JSONDecoder().decode(T.self, from: data) else {
        completionHandler(.failure(.decodeError))
        return
      }
      
      completionHandler(.success(products))
    }.resume()
  }
}
