//
//  JsonProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/25.
//

import Foundation

protocol JsonProtocol: URLRequestProtocol {
  func setJsonBody<T:Encodable>(httpMethod: HttpMethod,
                                apiRequestType: RequestType,
                                product: T) -> URLRequest?
}

extension JsonProtocol {
  func setJsonBody<T:Encodable>(httpMethod: HttpMethod, apiRequestType: RequestType,
                   product: T) -> URLRequest? {
    guard var urlRequest = makeURLRequest(httpMethod: httpMethod,
                                          apiRequestType: apiRequestType) else { return nil }
    guard let encodedData = try? JSONEncoder().encode(product) else { return nil }
    
    urlRequest.httpBody = encodedData
    return urlRequest
  }
}
