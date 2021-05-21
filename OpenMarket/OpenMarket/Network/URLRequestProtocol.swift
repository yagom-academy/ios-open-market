//
//  URLRequestProtocol.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/22.
//

import Foundation

protocol URLRequestProtocol: MultiPartProtocol {
  static var boundary: String { get }
  func makeURLRequest(httpMethod: HttpMethod, apiRequestType: RequestType) -> URLRequest?
  func setMultiPartBody(httpMethod: HttpMethod, apiRequestType: RequestType, product: Uploadable) -> URLRequest?
  func setJsonBody(httpMethod: HttpMethod, apiRequestType: RequestType, product: ProductDeleteRequest) -> URLRequest?
}

extension URLRequestProtocol {
  static var boundary: String {
    return UUID().uuidString
  }
  
  func makeURLRequest(httpMethod: HttpMethod, apiRequestType: RequestType) -> URLRequest? {
    guard let url = apiRequestType.url else { return nil }
    var urlRequest = URLRequest(url: url)
    let contentType = httpMethod.makeContentTypeText(boundary: Self.boundary)
    
    urlRequest.httpMethod = httpMethod.description
    urlRequest.setValue(contentType, forHTTPHeaderField: HttpMethod.contentType)
    
    return urlRequest
  }
  
  func setMultiPartBody(httpMethod: HttpMethod, apiRequestType: RequestType, product: Uploadable) -> URLRequest? {
    guard var urlRequest = makeURLRequest(httpMethod: httpMethod, apiRequestType: apiRequestType) else { return nil }
    var data: Data = Data()
    
    product.parameters.forEach { key, value in
      if let images = value as? [Data] {
        data.append(makeBodyForImage(boundary: Self.boundary, parameter: key, images: images))
      } else if let value = value {
        data.append(makeBodyForNormal(boundary: Self.boundary, parameter: key, value: value))
      }
    }
    
    data.appendString("--\(Self.boundary)--\r\n")
    urlRequest.httpBody = data
    return urlRequest
  }
  
  func setJsonBody(httpMethod: HttpMethod, apiRequestType: RequestType, product: ProductDeleteRequest) -> URLRequest? {
    guard var urlRequest = makeURLRequest(httpMethod: httpMethod, apiRequestType: apiRequestType) else { return nil }
    guard let encodedData = try? JSONEncoder().encode(product) else { return nil }
    
    urlRequest.httpBody = encodedData
    return urlRequest
  }
}
