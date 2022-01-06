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
  
  static func productList(pageNumber: String, itemsPerPage: String) throws -> URL {
    let pageNumber = URLQueryItem(name: "page-no", value: "\(pageNumber)")
    let itemsPerPage = URLQueryItem(name: "items-per-page", value: itemsPerPage)
    host?.path = "/api/products"
    host?.queryItems = [pageNumber, itemsPerPage]
    
    guard let url = host?.url else {
      throw error.urlGenerateFailed
    }
    
    return url
  }
  
  static func DetailProduct(productId: Int) throws -> URL {
    host?.path = "/api/products/\(productId)"
    guard let url = host?.url else {
      throw error.urlGenerateFailed
    }
    
    return url
  }
}
