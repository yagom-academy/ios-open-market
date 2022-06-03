//
//  EndPoint.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/29.
//

import Foundation

enum Endpoint {
    case healthChecker
    case productList(pageNumber: Int, itemsPerPage: Int)
    case productRegistration
    case productEdit(productId: Int)
    case productDelete(productId: Int, secret: String)
    case productSecretCheck(productId: Int)
}

extension Endpoint {
  var url: URL? {
    switch self {
    case .healthChecker:
      return .makeUrl(with: "healthChecker")
    case .productList(let page, let itemsPerPage):
      return .makeUrl(with: "api/products?page_no=\(page)&items_perpage=\(itemsPerPage)")
    case .productRegistration:
      return .makeUrl(with: "api/products")
    case .productEdit(let productId):
      return .makeUrl(with: "api/products/\(productId)")
    case .productDelete(let productId, let secret):
        return .makeUrl(with: "api/products/\(productId)/\(secret)")
    case .productSecretCheck(let productId):
        return .makeUrl(with: "api/products/\(productId)/secret")
    }
  }
}

private extension URL {
  static let baseURL = "https://market-training.yagom-academy.kr/"
  
  static func makeUrl(with endpoint: String) -> URL? {
    return URL(string: baseURL + endpoint)
  }
}
