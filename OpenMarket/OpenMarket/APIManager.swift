//
//  APIManager.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/04.
//

import Foundation

struct APIManager {
  private let urlSession: URLSession
  
  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }
  
  func productList(
    pageNumber: Int,
    itemsPerPage: Int,
    completion: @escaping (Result<ProductList, ResponseError>) -> Void
  ) {
    do{
      let url = try URLGenerator.productList(
        pageNumber: pageNumber,
        itemsPerPage: itemsPerPage)
      let request = URLRequest(url: url, httpMethod: .get)
      
      let dataTask = urlSession.dataTask(request) { response in
        switch response {
        case .success(let data):
          let result = JSONParser.shared.decode(data: data, type: ProductList.self)
          switch result {
          case .success(let data):
            completion(.success(data))
          case .failure(let error):
            print(error)
          }
        case .failure(_):
          completion(.failure(.responseFailed))
        }
      }
      dataTask.resume()
    } catch let error {
      print(error)
    }
  }
  
  func detailProduct(
    productId: Int,
    completion: @escaping (Result<Product, ResponseError>) -> Void
  ) {
    do {
      let url = try URLGenerator.DetailProduct(productId: productId)
      let request = URLRequest(url: url, httpMethod: .get)

      let dataTask = urlSession.dataTask(request) { response in
        switch response {
        case .success(let data):
          let result = JSONParser.shared.decode(data: data, type: Product.self)
          switch result {
          case .success(let data):
            completion(.success(data))
          case .failure(let error):
            print(error)
          }
        case .failure(_):
          completion(.failure(.responseFailed))
        }
      }
      dataTask.resume()
    } catch let error {
      print(error)
    }
  }
}
