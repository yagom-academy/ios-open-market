//
//  APIManager.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/04.
//

import Foundation

struct APIManager {
  let apiHost = "https://market-training.yagom-academy.kr"
  
  func productList(pageNumber: Int, itemsPerPage: Int) -> ProductList? {
    var productList: ProductList?
    guard let url = URL(string: apiHost +
                        "/api/products?page-no=\(pageNumber)&items-per-page=\(itemsPerPage)") else {
      return nil
    }
    var request = URLRequest(url: url, timeoutInterval: Double.infinity)
    request.httpMethod = "GET"

    URLSession.shared.dataTask(request) { response in
      switch response {
      case .success(let data):
        productList = JSONParser<ProductList>.decode(data: data)
      case .failure(_):
        productList = nil
      }
    }
    return productList
  }
  
  func DetailProduct(productId: Int) -> Product? {
    var product: Product?
    guard let url = URL(string: apiHost +
                        "/api/products/\(productId)") else {
      return nil
    }
    var request = URLRequest(url: url, timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    URLSession.shared.dataTask(request) { response in
      switch response {
      case .success(let data):
        product = JSONParser<Product>.decode(data: data)
        dump(product)
      case .failure(_):
        product = nil
      }
    }
    return product
  }
  
}
