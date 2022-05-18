//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum HttpMethod {
  static let get = "GET"
}

struct ApiProvider<T: Decodable> {
  private let session: URLSessionProtocol
  
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  func get(_ endpoint: Endpoint,
           completionHandler: @escaping (Result<T, NetworkError>) -> Void)
  {
    guard let url = endpoint.url else {
      completionHandler(.failure(.invalid))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = HttpMethod.get
    
    session.dataTask(with: request) { data, response, error in
      guard error == nil else {
        completionHandler(.failure(.invalid))
        return
      }
      guard let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode)
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
