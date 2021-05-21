//
//  RequestType.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/20.
//

import Foundation

enum RequestType {
  case loadPage(page: Int)
  case loadProduct(id: Int)
  case postProduct
  case patchProduct(id: Int)
  case deleteProduct(id: Int)
  
  static let baseURL: String = "https://camp-open-market-2.herokuapp.com"
  private var urlPath: String {
    switch self {
    case .loadPage(let page):
      return "/items/\(page)"
    case .loadProduct(let id):
      return "/item/\(id)"
    case .postProduct:
      return "/item/"
    case .patchProduct(let id):
      return "/item/\(id)"
    case .deleteProduct(let id):
      return "/item/\(id)"
    }
  }
  
  var url: URL? {
    return URL(string: "\(RequestType.baseURL)\(urlPath)")
  }
  
  var httpMethod: HttpMethod {
    switch self {
    case .loadPage:
      return .get
    case .loadProduct:
      return .get
    case .postProduct:
      return .post
    case .patchProduct:
      return .patch
    case .deleteProduct:
      return .delete
    }
  }
}
