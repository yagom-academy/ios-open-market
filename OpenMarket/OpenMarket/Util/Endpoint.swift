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
  private enum Url {
    static let base = "https://market-training.yagom-academy.kr/"
    static let pass = "api/products/"
  }
  
  var url: URL? {
    switch self {
    case .healthChecker:
      return URL(string: Url.base + "healthChecker")
    case .page(let page, let itemsPerPage):
      return URL(string: Url.base + Url.pass + "?page_no=\(page)&items_perpage=\(itemsPerPage)")
    case .registration:
      return URL(string: Url.base + Url.pass)
    case .productInformation(let productId):
      return URL(string: Url.base + Url.pass + "\(productId)")
    case .secretKey(let productId):
      return URL(string: Url.base + Url.pass + "\(productId)/secret")
    case .delete(let productId, let productSecret):
      return URL(string: Url.base + Url.pass + "\(productId)/\(productSecret)")
    }
  }
}
