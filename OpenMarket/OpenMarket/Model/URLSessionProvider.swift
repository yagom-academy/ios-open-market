//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

struct URLSessionProvider {
  private let hostApi = "https://market-training.yagom-academy.kr"
  private let session: URLSession
  private let path: String
  
  init(session: URLSession = URLSession.shared, path: String = "") {
      self.session = session
      self.path = path
  }
  
  func get(completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
    guard let url = URL(string: hostApi + path) else {
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
      
      completionHandler(.success(data))
    }.resume()
  }
}
