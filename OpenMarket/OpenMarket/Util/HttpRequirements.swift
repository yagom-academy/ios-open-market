//
//  HttpRequirements.swift
//  OpenMarket
//
//  Created by 조성훈 on 2022/06/03.
//

import Foundation

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case patch = "PATCH"
  case delete = "DELETE"
}

protocol Apiable {
  var endpoint: Endpoint { get }
  var httpMethod: HttpMethod { get }
  
  func verifyMethod() -> HttpMethod
}

final class HttpRequirements: Apiable {
  var endpoint: Endpoint
  var httpMethod: HttpMethod = .get
  
  init(endpoint: Endpoint) {
    self.endpoint = endpoint
    self.httpMethod = verifyMethod()
  }
  
  func verifyMethod() -> HttpMethod {
    switch endpoint {
    case .healthChecker:
      return .get
    case .page:
      return .get
    case .registration:
      return .post
    case .productInformation:
      return .get
    case .edit:
      return .patch
    case .secretKey:
      return .post
    case .delete:
      return .delete
    }
  }
}
