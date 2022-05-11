//
//  APINetworkService.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/11.
//

import Foundation

enum Constant {
  static let baseURL = "https://market-training.yagom-academy.kr/"
  static let productsPath = "api/products?page_no=1&items_per_page=10"
  static let productPath = "api/products/"
  static let healthCheckerPath = "healthChecker"
}

class APINetworkService: NetworkService {
  private let urlSession: URLSessionProtocol
  
  init(urlSession: URLSessionProtocol) {
    self.urlSession = urlSession
  }
  
  func checkHealth(_ completion: @escaping (Result<String, APINetworkError>) -> Void) {
    let urlString = Constant.baseURL + Constant.healthCheckerPath
    guard let url = URL(string: urlString) else { return }
    
    let task = self.urlSession.dataTask(with: url) { data, response, error in
      guard error == nil else { return }
      guard let response = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      
      switch response.statusCode {
      case 200...299:
        if let text = String(data: data, encoding: .utf8) { completion(.success(text)) }
      case 400:
        completion(.failure(.badRequest))
      default:
        break
      }
    }
    task.resume()
  }
  
  func fetchProductAll(_ completion: @escaping (Result<[Product], APINetworkError>) -> Void) {
    let urlString = Constant.baseURL + Constant.productsPath
    guard let url = URL(string: urlString) else { return }
    
    let task = self.urlSession.dataTask(with: url) { data, response, error in
      guard error == nil else { return }
      guard let response = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      
      guard let apiResponse = try? JSONDecoder().decode(APIResponse.self, from: data) else { return }
      
      switch response.statusCode {
      case 200...299:
        completion(.success(apiResponse.pages))
      case 400:
        completion(.failure(.badRequest))
      default:
        break
      }
    }
    task.resume()
  }
  
  func fetchProductOne(productID: Int, _ completion: @escaping (Result<Product, APINetworkError>) -> Void) {
    let urlString = Constant.baseURL + Constant.productPath + String(productID)
    guard let url = URL(string: urlString) else { return }
    
    let task = self.urlSession.dataTask(with: url) { data, response, error in
      guard error == nil else { return }
      guard let response = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      
      guard let product = try? JSONDecoder().decode(Product.self, from: data) else { return }
      
      switch response.statusCode {
      case 200...299:
        completion(.success(product))
      case 400:
        completion(.failure(.badRequest))
      default:
        break
      }
    }
    task.resume()
  }
}

