//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum HttpMethod {
  static let get = "GET"
  static let post = "POST"
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

extension ApiProvider {
  func post(_ endpoint: Endpoint, _ params: Params, _ images: [ImageFile], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
    
    guard let url = endpoint.url else {
      completionHandler(.failure(.invalid))
      return
    }
    
    var request = URLRequest(url: url)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.httpMethod = HttpMethod.post
    request.setValue("cd706a3e-66db-11ec-9626-796401f2341a", forHTTPHeaderField: "identifier")
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
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
      
      completionHandler(.success(data))
    }.resume()
  }
  
  
  
  func setupBody(params: Params, images: [ImageFile], boundary: String) -> Data? {
    var body = Data()
    return body
  }
}
