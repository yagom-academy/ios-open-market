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
  private let urlSession: URLSession
  
  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }
  
  func productList(
    pageNumber: Int,
    itemsPerPage: Int,
    complition: @escaping (Result<ProductList, ResponseError>) -> Void
  ) {
    do{
      let url = try URLGenerator.productList(
        pageNumber: "\(pageNumber)",
        itemsPerPage: "\(itemsPerPage)")
      var request = URLRequest(url: url)
      request.httpMethod = HttpMethod.get
      
      let dataTask = urlSession.dataTask(request) { response in
        switch response {
        case .success(let data):
          let result = JSONParser.shared.decode(data: data, type: ProductList.self)
          switch result {
          case .success(let data):
            complition(.success(data))
          case .failure(let error):
            print(error)
          }
        case .failure(_):
          complition(.failure(.responseFailed))
        }
      }
      dataTask.resume()
    } catch let error {
      print(error)
    }
  }
  
  func detailProduct(
    productId: Int,
    complition: @escaping (Result<Product, ResponseError>) -> Void
  ) {
    do {
      let url = try URLGenerator.DetailProduct(productId: productId)
      var request = URLRequest(url: url)
      request.httpMethod = HttpMethod.get
      
      let dataTask = urlSession.dataTask(request) { response in
        switch response {
        case .success(let data):
          let result = JSONParser.shared.decode(data: data, type: Product.self)
          switch result {
          case .success(let data):
            complition(.success(data))
          case .failure(let error):
            print(error)
          }
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
