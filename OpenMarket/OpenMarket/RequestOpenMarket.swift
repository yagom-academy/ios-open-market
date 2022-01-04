//
//  request.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/03.
//

import UIKit

class RequestOpenMarket {
  let apiHost = "https://market-training.yagom-academy.kr"
  
  func productList(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<ProductList, Error>) -> ()) {
    guard let url = URL(string: apiHost +
                        "/api/products?page-no=\(pageNumber)&items-per-page=\(itemsPerPage)") else {
      return
    }

    var request = URLRequest(url: url, timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { data, response, error in
      guard error == nil else {
        print("Error: error calling GET")
        print(error!)
        return
      }
      guard let data = data else {
        print("Error: Did not receive data")
        return
      }
      guard let response = response as? HTTPURLResponse,
        (200..<300) ~= response.statusCode else {
          print("Error: HTTP request failed")
        return
      }
      guard let output = try? JSONDecoder().decode(ProductList.self, from: data) else {
        print("Error: JSON Data Parsing failed")
        return
      }
      return completion(.success(output))
      
    }.resume()
    
  }
  
  func response() -> ProductList? {
    var v: ProductList?
    productList(pageNumber: 1, itemsPerPage: 10) { response in
      switch response {
      case .success(let data):
        v = data
      case .failure(let data):
        v = nil
      }
    }
    return v
  }
  
  func detailProduct(productId: Int, completion: @escaping (Result<Product, Error>) -> ()) {
    guard let url = URL(string: apiHost +
                        "/api/products/\(productId)") else {
      return
    }
    var request = URLRequest(url: url, timeoutInterval: Double.infinity)
    request.httpMethod = "GET"
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { data, response, error in
      guard error == nil else {
        print("Error: error calling GET")
        print(error!)
        return
      }
      guard let data = data else {
        print("Error: Did not receive data")
        return
      }
      guard let response = response as? HTTPURLResponse,
        (200..<300) ~= response.statusCode else {
          print("Error: HTTP request failed")
        return
      }
      guard let output = try? JSONDecoder().decode(Product.self, from: data) else {
        print("Error: JSON Data Parsing failed")
        return
      }
      return completion(.success(output))
      
    }.resume()
  }
  
  func responseDetailProduct() -> Product? {
    var v: Product?
    detailProduct(productId: 16) { response in
      switch response {
      case .success(let data):
        v = data
        dump(v)
      case .failure(let data):
        v = nil
      }
    }
    return v
  }
}
