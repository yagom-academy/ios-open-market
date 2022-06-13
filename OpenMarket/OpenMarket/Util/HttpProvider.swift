//
//  HttpProvider.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

struct HttpProvider {
  private enum UserInfo {
    static let identifier = "8de44ec8-d1b8-11ec-9676-43acdce229f5"
  }
  
  private let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  func execute(
    _ networkRequirements: HttpRequirements,
    completionHandler: @escaping (Result<Data, NetworkError>) -> Void
  ) {
    guard let url = networkRequirements.endpoint.url else {
      completionHandler(.failure(.invalid))
      return
    }
    
    let boundary = "Boundary-\(UUID().uuidString)"
    var request = URLRequest(url: url)
    request.httpMethod = networkRequirements.httpMethod.rawValue
    
    switch networkRequirements.endpoint {
    case .healthChecker:
      break
      
    case .page:
      break
      
    case .registration(let params, let images):
      request.setValue(UserInfo.identifier, forHTTPHeaderField: "identifier")
      request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
      request.httpBody = setUpPostBody(params, images, boundary)
      
    case .productInformation:
      break
      
    case .edit(_, let params):
      request.setValue(UserInfo.identifier, forHTTPHeaderField: "identifier")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = setUpPatchBody(params)
      
    case .secretKey(_, let secret):
      request.setValue(UserInfo.identifier, forHTTPHeaderField: "identifier")
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = "{\"secret\": \"\(secret)\"}".data(using: .utf8)
      
    case .delete:
      request.setValue(UserInfo.identifier, forHTTPHeaderField: "identifier")
    }
    
    executeDataTask(with: request, completionHandler)
  }
  
  private func setUpPostBody(_ params: Params, _ images: [ImageFile], _ boundary: String) -> Data? {
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
  
  private func setUpPatchBody(_ params: Params) -> Data? {
    guard let jsonData = try? JSONEncoder().encode(params) else {
      return nil
    }
    var body = Data()
    body.append(jsonData)
    return body
  }
  
  private func executeDataTask(
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
}

