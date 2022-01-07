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

enum responseError: Error {
  case jsonParsingError
  case responseFailed
}

struct APIManager {
  let semaphore = DispatchSemaphore(value: 0)
  let urlSession: URLSession
  
  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }
  
  func productList(pageNumber: Int, itemsPerPage: Int, complition: @escaping (Result<ProductList, responseError>) -> Void) {
    do{
      let url = try URLGenerator.productList(pageNumber: "1", itemsPerPage: "10")
      var request = URLRequest(url: url)
      request.httpMethod = HttpMethod.get
      
      let dataTask = urlSession.dataTask(request) { response in
        switch response {
        case .success(let data):
          guard let productList = JSONParser<ProductList>.decode(data: data) else {
            complition(.failure(.jsonParsingError))
            return
          }
          complition(.success(productList))
        case .failure(_):
          complition(.failure(.responseFailed))
        }
      }
      dataTask.resume()
    } catch let error {
      print(error)
    }
  }
  
  func DetailProduct(productId: Int, complition: @escaping (Result<Product, responseError>) -> Void) {
    do {
      let url = try URLGenerator.DetailProduct(productId: productId)
      var request = URLRequest(url: url)
      request.httpMethod = HttpMethod.get
      
      let dataTask = urlSession.dataTask(request) { response in
        switch response {
        case .success(let data):
          guard let product = JSONParser<Product>.decode(data: data) else {
            complition(.failure(.jsonParsingError))
            return
          }
          complition(.success(product))
        case .failure(_):
          complition(.failure(.responseFailed))
        }
      }
      dataTask.resume()
    } catch let error {
      print(error)
    }
  }
}
