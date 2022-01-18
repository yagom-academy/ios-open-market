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
  
  static func productListURL(pageNumber: Int, itemsPerPage: Int) -> URL? {
    let pageNumber = URLQueryItem(name: "page_no", value: "\(pageNumber)")
    let itemsPerPage = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
    host?.path = "/api/products"
    host?.queryItems = [pageNumber, itemsPerPage]
    let url = host?.url
    
    return url
  }
  
  static func productDetailURL(productId: Int) -> URL? {
    host?.path = "/api/products/\(productId)"
    let url = host?.url
    
    return url
  }
  
  static func productAdditionURL() -> URL? {
    host?.path = "/api/products"
    let url = host?.url
    
    return url
  }
  
  static func productModificationURL(productId: Int) -> URL? {
    host?.path = "/api/products/\(productId)"
    let url = host?.url
    
    return url
  }
  
  static func getDeleteProductSecretURL(productId: Int) -> URL? {
    host?.path = "/api/products/\(productId)/secret"
    let url = host?.url
    
    return url
  }
  
  static func getDeleteProductURL(productId: Int, productSecret: String) -> URL? {
    host?.path = "/api/products/\(productId)/\(productSecret)"
    let url = host?.url
    
    return url
  }
}
