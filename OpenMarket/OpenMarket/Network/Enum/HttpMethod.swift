//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

enum HttpMethod: CustomStringConvertible {
  case get, post, put, patch, delete
  
  var description: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .put:
      return "PUT"
    case .patch:
      return "PATCH"
    case .delete:
      return "DELETE"
    }
  }
  
  static let contentType = "Content-Type"

  func makeContentTypeText(boundary: String) -> String {
    switch self {
    case .get, .delete, .put:
      return "Application/json"
    case .patch, .post:
      return "multipart/form-data; boundary=\(boundary)"
    }
  }
}
