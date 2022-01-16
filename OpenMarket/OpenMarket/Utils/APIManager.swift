//
//  APIManager.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/04.
//

import Foundation

struct APIManager {
  private let urlSession: URLSession
  private let jsonParser = JSONParser()
  
  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }
  
  func productList(
    pageNumber: Int,
    itemsPerPage: Int,
    completion: @escaping (Result<ProductList, Error>) -> Void
  ) {
    do{
      let url = try URLGenerator.productList(
        pageNumber: pageNumber,
        itemsPerPage: itemsPerPage)
      let request = URLRequest(url: url, httpMethod: .get)
      
      let dataTask = urlSession.dataTask(request) { response in
        switch response {
        case .success(let data):
          let result = jsonParser.decode(data: data, type: ProductList.self)
          switch result {
          case .success(let data):
            completion(.success(data))
          case .failure(let error):
            completion(.failure(error))
          }
        case .failure(_):
          completion(.failure(ResponseError.responseFailed))
        }
      }
      dataTask.resume()
    } catch let error {
      completion(.failure(error))
    }
  }
  
  func detailProduct(
    productId: Int,
    completion: @escaping (Result<Product, Error>) -> Void
  ) {
    do {
      let url = try URLGenerator.detailProduct(productId: productId)
      let request = URLRequest(url: url, httpMethod: .get)

      let dataTask = urlSession.dataTask(request) { response in
        switch response {
        case .success(let data):
          let result = jsonParser.decode(data: data, type: Product.self)
          switch result {
          case .success(let data):
            completion(.success(data))
          case .failure(let error):
            completion(.failure(error))
          }
        case .failure(_):
          completion(.failure(ResponseError.responseFailed))
        }
      }
      dataTask.resume()
    } catch let error {
      completion(.failure(error))
    }
  }
}
