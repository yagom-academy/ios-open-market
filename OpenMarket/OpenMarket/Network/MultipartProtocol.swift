//
//  MultiPartProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/25.
//

import Foundation

protocol MultiPartProtocol: URLRequestProtocol {
  func setMultiPartBody(httpMethod: HttpMethod,
                        apiRequestType: RequestType,
                        product: Encodable) -> URLRequest?
  func makeBodyForImage(imageName: String, images: [Data], boundary: String) -> Data
  func makeBodyForNormal(name: String, value: Any, boundary: String) -> Data
}

extension MultiPartProtocol {
  func setMultiPartBody(httpMethod: HttpMethod,
                        apiRequestType: RequestType,
                        product: Encodable) -> URLRequest? {
    guard var urlRequest = makeURLRequest(httpMethod: httpMethod,
                                          apiRequestType: apiRequestType) else { return nil }
    var data: Data = Data()
    let mirror = Mirror(reflecting: product)
    
    mirror.children.forEach { key, value in
      guard let key = key else { return }
      if let images = value as? [Data] {
        data.append(makeBodyForImage(imageName: key, images: images, boundary: Self.boundary))
      } else {
        data.append(makeBodyForNormal(name: key, value: value, boundary: Self.boundary))
      }
    }
    
    data.appendString("--\(Self.boundary)--\r\n")
    urlRequest.httpBody = data
    return urlRequest
  }
  
  func makeBodyForImage(imageName: String, images: [Data], boundary: String) -> Data {
    var data = Data()
    
    for image in images {
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"images[]\"; filename=\"\(imageName)\"\r\n")
      data.appendString("Content-Type: image/png\r\n\r\n")
      data.append(image)
      data.appendString("\r\n")
    }
    
    return data
  }
  
  func makeBodyForNormal(name: String, value: Any, boundary: String) -> Data {
    var data = Data()
    
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
    data.appendString("\(value)\r\n")
    
    return data
  }
}

