//
//  Endpoint.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum Endpoint {
  case healthChecker
  case page(pageNumber: Int, itemsPerPage: Int)
  case registration
  case productInformation(productId: Int)
  case secretKey(productId: Int)
  case delete(productId: Int, productSecret: String)
}

extension Endpoint {
  var url: URL? {
    switch self {
    case .healthChecker:
      return .makeUrl(with: "healthChecker")
    case .page(let page, let itemsPerPage):
      return .makeUrl(with: "api/products?page_no=\(page)&items_perpage=\(itemsPerPage)")
    case .registration:
      return .makeUrl(with: "api/products")
    case .productInformation(let productId):
      return .makeUrl(with: "api/products/\(productId)")
    case .secretKey(let productId):
      return .makeUrl(with: "api/products/\(productId)/secret")
    case .delete(let productId, let productSecret):
      return .makeUrl(with: "api/products/\(productId)/\(productSecret)")
    }
  }
}

private extension URL {
  static let baseURL = "https://market-training.yagom-academy.kr/"
  
  static func makeUrl(with endpoint: String) -> URL? {
    return URL(string: baseURL + endpoint)
  }
}
