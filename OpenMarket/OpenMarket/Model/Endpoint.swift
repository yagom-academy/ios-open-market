//
//  Endpoint.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum Endpoint {
  case healthChecker
  case productList(pageNumber: Int, itemsPerPage: Int)
}

extension Endpoint {
  var url: URL? {
    switch self {
    case .healthChecker:
      return .makeUrl(with: "healthChecker")
    case .productList(let page, let itemsPerPage):
      return .makeUrl(with: "api/products?page_no=\(page)&items_perpage=\(itemsPerPage)")
    }
  }
}

private extension URL {
  static let baseURL = "https://market-training.yagom-academy.kr/"
  
  static func makeUrl(with endpoint: String) -> URL? {
    return URL(string: baseURL + endpoint)
  }
}
