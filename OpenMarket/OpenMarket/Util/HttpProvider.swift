//
//  HttpProvider.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum HttpMethod {
  static let get = "GET"
  static let post = "POST"
  static let patch = "PATCH"
  static let delete = "DELETE"
}

struct HttpProvider {
  private let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func excuteDataTask(
    with request: URLRequest,
    _ completionHandler: @escaping (Result<Data, NetworkError>) -> Void
  ) {
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
  
  func get(
    _ endpoint: Endpoint,
    completionHandler: @escaping (Result<Data, NetworkError>) -> Void
  ) {
    guard let url = endpoint.url else {
      completionHandler(.failure(.invalid))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = HttpMethod.get
    
    excuteDataTask(with: request, completionHandler)
  }
  
  func post(
    _ endpoint: Endpoint,
    _ params: Params,
    _ images: [ImageFile],
    completionHandler: @escaping (Result<Data, NetworkError>) -> Void
  ) {
    guard let url = endpoint.url else {
      completionHandler(.failure(.invalid))
      return
    }
    
    var request = URLRequest(url: url)
    let boundary = "Boundary-\(UUID().uuidString)"
    request.httpMethod = HttpMethod.post
    request.setValue("8de44ec8-d1b8-11ec-9676-43acdce229f5", forHTTPHeaderField: "identifier")
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpBody = setupBody(params, images, boundary)
    
    excuteDataTask(with: request, completionHandler)
  }
  
  func setupBody(_ params: Params, _ images: [ImageFile], _ boundary: String) -> Data? {
    guard let jsonData = try? JSONEncoder().encode(params) else {
      return nil
    }
    var body = Data()
    body.appendString("\r\n--\(boundary)\r\n")
    body.appendString("Content-Disposition: form-data; name=\"params\"\r\n")
    body.appendString("Content-Type: application/json\r\n")
    body.appendString("\r\n")
    body.append(jsonData)
    body.appendString("\r\n")
    
    for image in images {
      body.appendString("--\(boundary)\r\n")
      body.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(image.fileName)\"\r\n")
      body.appendString("Content-Type: image/\(image.type)\r\n")
      body.appendString("\r\n")
      body.append(image.data)
      body.appendString("\r\n")
    }
    body.appendString("\r\n--\(boundary)--\r\n")
    
    return body
  }
  
  func patch(
    _ endpoint: Endpoint,
    _ params: Params,
    completionHandler: @escaping (Result<Data, NetworkError>) -> Void
  ) {
    guard let url = endpoint.url else {
      completionHandler(.failure(.invalid))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = HttpMethod.patch
    request.setValue("8de44ec8-d1b8-11ec-9676-43acdce229f5", forHTTPHeaderField: "identifier")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = setupBody(params)
    
    excuteDataTask(with: request, completionHandler)
  }
  
  func setupBody(_ params: Params) -> Data? {
    guard let jsonData = try? JSONEncoder().encode(params) else {
      return nil
    }
    var body = Data()
    body.append(jsonData)
    return body
  }
}

extension HttpProvider {
  func serachSecret(
    _ endpoint: Endpoint, _ secret: Secret,
    completionHandler: @escaping (Result<Data, NetworkError>) -> Void
  ) {
    guard let url = endpoint.url else {
      completionHandler(.failure(.invalid))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = HttpMethod.post
    request.setValue("8de44ec8-d1b8-11ec-9676-43acdce229f5", forHTTPHeaderField: "identifier")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = setupBody(secret)
    
    executeDataTask(with: request, completionHandler)
  }
  
  func setupBody(_ secret: Secret) -> Data? {
    guard let jsonData = try? JSONEncoder().encode(secret) else {
      return nil
    }
    var body = Data()
    body.append(jsonData)
    return body
  }
}

extension HttpProvider {
  func delete(
    _ endpoint: Endpoint,
    completionHandler: @escaping (Result<Data, NetworkError>) -> Void
  ) {
    guard let url = endpoint.url else {
      completionHandler(.failure(.invalid))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = HttpMethod.delete
    request.setValue("8de44ec8-d1b8-11ec-9676-43acdce229f5", forHTTPHeaderField: "identifier")
    
    excuteDataTask(with: request, completionHandler)
  }
}
