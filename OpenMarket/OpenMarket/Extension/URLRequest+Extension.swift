//
//  URLRequest+Extension.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/10.
//

import Foundation

extension URLRequest {
  enum HttpMethod {
    case get
    case post
    case patch
    case delete
  }
  
  init(url: URL, httpMethod: HttpMethod){
    self.init(url: url)
    
    switch httpMethod {
    case .get:
      self.httpMethod = "GET"
    case .post:
      self.httpMethod = "POST"
    case .delete:
      self.httpMethod = "DELETE"
    case .patch:
      self.httpMethod = "PATCH"
    }
  }
}
