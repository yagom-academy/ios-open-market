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
  func makeBodyForImage(boundary: String, parameter: String, images: [Data]) -> Data
  func makeBodyForNormal(boundary: String, parameter: String, value: Any?) -> Data
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
        data.append(makeBodyForImage(boundary: Self.boundary, parameter: key, images: images))
      } else {
        data.append(makeBodyForNormal(boundary: Self.boundary, parameter: key, value: value))
      }
    }
    
    data.appendString("--\(Self.boundary)--\r\n")
    urlRequest.httpBody = data
    return urlRequest
  }
  
  func makeBodyForImage(boundary: String, parameter: String, images: [Data]) -> Data {
    var data = Data()
    var imageIndex = 1
    
    images.forEach { image in
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(parameter)[]\"; filename=\"image\(imageIndex).png\"\r\n")
      data.appendString("Content-Type: image/png\r\n\r\n")
      data.append(image)
      data.appendString("\r\n")
      imageIndex += 1
    }
    
    return data
  }
  
  func makeBodyForNormal(boundary: String, parameter: String, value: Any?) -> Data {
    var data = Data()
    
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(parameter)\"\r\n\r\n")
    if let value = value as? Int{
      data.appendString(String(value))
    } else if let value = value as? String {
      data.appendString(value)
    }
    data.appendString("\r\n")
    
    return data
  }
}

