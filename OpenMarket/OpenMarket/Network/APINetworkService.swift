//
//  APINetworkService.swift
//  OpenMarket
//  Created by Lingo, Quokka on 2022/05/11.
//

import UIKit

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
    guard let url = URL(string: urlString) else { return }
    let urlRequest = URLRequest(url: url)
    
    self.request(with: urlRequest) { result in
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
    guard let url = makeURL(
      url: urlString,
      queryItems: ["page_no": pageNumber, "items_per_page": itemsPerPage]
    ) else { return }
    let urlRequset = URLRequest(url: url)

    self.request(with: urlRequset) { result in
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
    guard let url = URL(string: urlString) else { return }
    let urlRequest = URLRequest(url: url)
    self.request(with: urlRequest) { result in
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
  
  func registerProduct(_ product: ProductRequest) {
    let urlString = Constant.baseURL + Constant.productDetailPath
    guard let url = URL(string: urlString) else { return }
    
    let boundary = UUID().uuidString
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.addValue("f81d1b5f-d1b7-11ec-9676-094e9d1692c2", forHTTPHeaderField: "identifier")
    urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var data = Data()
    data.appendString("\r\n--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"params\"\r\n")
    data.appendString("Content-Type: application/json\r\n\r\n")
    data.appendString("""
    {
    \"name\": \"\(product.name)\",
    \"price\": \(product.price),
    \"discounted_price\": \(product.discountedPrice),
    \"currency\": \"\(product.currency.rawValue)\",
    \"stock\": \(product.stock),
    \"descriptions\": \"\(product.description)\",
    \"secret\": \"9vylftzug8\"
    }
    """)
    for image in product.images {
      data.appendString("\r\n--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"image.jpg\"\r\n")
      data.appendString("Content-Type: image/jpg\r\n\r\n")
      
      guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
      data.append(imageData)
    }
    data.appendString("\r\n--\(boundary)--\r\n")
    urlRequest.httpBody = data
  
    self.request(with: urlRequest) { _ in }
  }
  
  private func request(
    with urlRequest: URLRequest,
    _ completion: @escaping (Result<Data, APINetworkError>) -> Void
  ) {
    self.urlSession.dataTask(with: urlRequest) { data, response, error in
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
    queryItems?.forEach { query in
      let queryItem = URLQueryItem(name: query.key, value: String(query.value))
      urlComponents?.queryItems?.append(queryItem)
    }
    return urlComponents?.url
  }
}
