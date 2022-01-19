//
//  URLRequest+Extension.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import Foundation

enum HttpMethod {
  case get
  case post
  case petch
  case delete
  
  var method: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .petch:
      return "PATCH"
    case .delete:
      return "DELETE"
    }
  }
}

extension URLRequest {
  init(url: URL, httpMethod: HttpMethod) {
    self.init(url: url)
    self.httpMethod = httpMethod.method
  }
  
}
