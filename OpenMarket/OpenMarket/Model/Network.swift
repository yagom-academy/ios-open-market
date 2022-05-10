//
//  Network.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum API {
    static let hostApi = "https://market-training.yagom-academy.kr"
    static func request() -> Network {
        Network(path: "/healthChecker")
    }
}

struct Network {
  private let session: URLSession
  private let path: String
  private let paramaters: [String: String]
  
  init(session: URLSession = URLSession.shared, path: String = "", paramaters: [String: String] = [:]) {
      self.session = session
      self.path = path
      self.paramaters = paramaters
  }
  
  func get(completionHandler: @escaping (Result<String, NetworkError>) -> Void) {
    var urlComponents = URLComponents(string: API.hostApi + path)
    urlComponents?.queryItems = paramaters.map {
      URLQueryItem(name: $0.key, value: $0.value)
    }
    
    guard let url = urlComponents?.url else {
      completionHandler(.failure(.invalid))
      return
    }
    
    session.dataTask(with: url) { data, response, error in
      guard error == nil else {
        completionHandler(.failure(.invalid))
        return
      }
      
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        return completionHandler(.failure(.statusCodeError))
      }
      
      guard let data = data else {
        completionHandler(.failure(.invalid))
        return
      }
      
      guard let text = String(data: data, encoding: .utf8) else {
        completionHandler(.failure(.invalid))
        return
      }
      
      completionHandler(.success(text))
    }.resume()
  }
}
