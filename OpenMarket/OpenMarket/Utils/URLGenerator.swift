//
//  URLGenerator.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/06.
//

import Foundation

enum URLGenerator {
  enum error: Error {
    case urlGenerateFailed
  }
  
  static var host = URLComponents(string: "https://market-training.yagom-academy.kr")
  
  static func productList(pageNumber: Int, itemsPerPage: Int) throws -> URL {
    let pageNumber = URLQueryItem(name: "page_no", value: "\(pageNumber)")
    let itemsPerPage = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
    host?.path = "/api/products"
    host?.queryItems = [pageNumber, itemsPerPage]
    
    guard let url = host?.url else {
      throw error.urlGenerateFailed
    }
    
    return url
  }
  
  static func detailProduct(productId: Int) throws -> URL {
    host?.path = "/api/products/\(productId)"
    guard let url = host?.url else {
      throw error.urlGenerateFailed
    }
    
    return url
  }
}
