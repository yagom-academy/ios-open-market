//
//  APIManager.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/04.
//

import Foundation

enum HttpMethod {
  static let get = "GET"
  static let post = "POST"
  static let patch = "PATCH"
  static let delete = "DELETE"
}

struct APIManager {
  let semaphore = DispatchSemaphore(value: 0)
  
  func productList(pageNumber: Int, itemsPerPage: Int) -> ProductList? {
    var productList: ProductList?
    do{
      let url = try URLGenerator.productList(pageNumber: "1", itemsPerPage: "10")
      var request = URLRequest(url: url)
      request.httpMethod = HttpMethod.get
      
      URLSession.shared.dataTask(request) { response in
        switch response {
        case .success(let data):
          productList = JSONParser<ProductList>.decode(data: data)
        case .failure(_):
          productList = nil
        }
        semaphore.signal()
      }
      semaphore.wait()
    } catch let error {
      print(error)
    }
    
    return productList
  }
  
  func DetailProduct(productId: Int) -> Product? {
    var product: Product?
    do {
      let url = try URLGenerator.DetailProduct(productId: productId)
      var request = URLRequest(url: url)
      request.httpMethod = HttpMethod.get
      URLSession.shared.dataTask(request) { response in
        switch response {
        case .success(let data):
          product = JSONParser<Product>.decode(data: data)
          dump(product)
        case .failure(_):
          product = nil
        }
        semaphore.signal()
      }
      semaphore.wait()
    } catch let error {
      print(error)
    }
    
    return product
  }
  
}
