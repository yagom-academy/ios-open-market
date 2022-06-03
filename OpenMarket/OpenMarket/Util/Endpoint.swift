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
  case registration(params: Params, images: [ImageFile])
  case productInformation(productId: Int)
  case edit(productId: Int, params: Params)
  case secretKey(productId: Int, secret: String)
  case delete(productId: Int, productSecret: String)
}

extension Endpoint {
  private enum Url {
    static let base = "https://market-training.yagom-academy.kr/"
    static let path = "api/products/"
  }
  
  var url: URL? {
    switch self {
    case .healthChecker:
      return URL(string: Url.base + "healthChecker")
      
    case .page(let page, let itemsPerPage):
      return URL(string: Url.base + Url.path + "?page_no=\(page)&items_perpage=\(itemsPerPage)")
      
    case .registration:
      return URL(string: Url.base + Url.path)
      
    case .productInformation(let productId):
      return URL(string: Url.base + Url.path + "\(productId)")
      
    case .edit(let productId,_):
      return URL(string: Url.base + Url.path + "\(productId)")
      
    case .secretKey(let productId,_):
      return URL(string: Url.base + Url.path + "\(productId)/secret")
      
    case .delete(let productId, let productSecret):
      return URL(string: Url.base + Url.path + "\(productId)/\(productSecret)")
    }
  }
}
