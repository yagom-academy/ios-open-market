//
//  APINetworkService.swift
//  OpenMarket
//  Created by Lingo, Quokka on 2022/05/11.
//

import Foundation

fileprivate enum Constant {
  static let baseURL = "https://market-training.yagom-academy.kr/"
  static let productListPath = "api/products?"
  static let productDetailPath = "api/products/"
  static let healthCheckerPath = "healthChecker"
}

final class APINetworkService: NetworkService {
  private let urlSession: URLSessionable
  
  init(urlSession: URLSessionable) {
    self.urlSession = urlSession
  }
  
  func checkHealth(
    _ completion: @escaping (Result<String, APINetworkError>) -> Void
  ) {
    let urlString = Constant.baseURL + Constant.healthCheckerPath
    
    self.request(url: urlString) { result in
      switch result {
      case let .success(data):
        guard let text = String(data: data, encoding: .utf8) else { return }
        completion(.success(text))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
  
  func fetchProductAll(
    pageNumber: Int,
    itemsPerPage: Int,
    _ completion: @escaping (Result<[Product], APINetworkError>) -> Void
  ) {
    let urlString = Constant.baseURL + Constant.productListPath
    let url = makeURL(url: urlString, queryItems: ["page_no": pageNumber, "items_per_page": itemsPerPage])
    
    self.request(url: url) { result in
      switch result {
      case let .success(data):
        guard let apiResponse = try? JSONDecoder().decode(APIResponse.self, from: data)
        else { return }
        let products = apiResponse.pages
        completion(.success(products))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
  
  func fetchProductOne(
    productID: Int,
    _ completion: @escaping (Result<Product, APINetworkError>) -> Void
  ) {
    let urlString = Constant.baseURL + Constant.productDetailPath + String(productID)
    
    self.request(url: urlString) { result in
      switch result {
      case let .success(data):
        guard let product = try? JSONDecoder().decode(Product.self, from: data)
        else { return }
        completion(.success(product))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
  
  private func request(
    url urlString: String,
    _ completion: @escaping (Result<Data, APINetworkError>) -> Void
  ) {
    guard let url = URL(string: urlString) else { return }
    
    self.urlSession.dataTask(with: url) { data, response, error in
      guard error == nil else { return }
      guard let response = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      
      switch response.statusCode {
      case 200...299:
        completion(.success(data))
      case 400:
        completion(.failure(.badRequest))
      default:
        break
      }
    }.resume()
  }
  
  private func request(
    url: URL?,
    _ completion: @escaping (Result<Data, APINetworkError>) -> Void
  ) {
    guard let url = url else { return }
    
    self.urlSession.dataTask(with: url) { data, response, error in
      guard error == nil else { return }
      guard let response = response as? HTTPURLResponse else { return }
      guard let data = data else { return }
      
      switch response.statusCode {
      case 200...299:
        completion(.success(data))
      case 400:
        completion(.failure(.badRequest))
      default:
        break
      }
    }.resume()
  }
}

// MARK: URLComponents Method

extension APINetworkService {
  private func makeURL(url urlString: String, queryItems: [String: Int]? = nil) -> URL? {
    var urlComponents = URLComponents(string: urlString)
    queryItems?.forEach({ queryItem in
      urlComponents?.queryItems?.append(URLQueryItem(name: queryItem.key, value: String(queryItem.value)))
    })
    return urlComponents?.url
  }
}
