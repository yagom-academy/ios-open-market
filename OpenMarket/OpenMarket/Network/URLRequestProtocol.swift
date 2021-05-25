//
//  URLRequestProtocol.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/22.
//

import Foundation

protocol URLRequestProtocol {
  static var boundary: String { get }
  func makeURLRequest(httpMethod: HttpMethod, apiRequestType: RequestType) -> URLRequest?
}

extension URLRequestProtocol {
  func makeURLRequest(httpMethod: HttpMethod, apiRequestType: RequestType) -> URLRequest? {
    guard let url = apiRequestType.url else { return nil }
    var urlRequest = URLRequest(url: url)
    let contentType = httpMethod.makeContentTypeText(boundary: Self.boundary)
    
    urlRequest.httpMethod = httpMethod.description
    urlRequest.setValue(contentType, forHTTPHeaderField: HttpMethod.contentType)
    
    return urlRequest
  }
}
