//
//  APIManager.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/04.
//

import Foundation
import UIKit

struct APIManager: RestFulAPI {
  private let urlSession: URLSession
  private let jsonParser: JSONParser
  
  init(urlSession: URLSession, jsonParser: JSONParser) {
    self.urlSession = urlSession
    self.jsonParser = jsonParser
  }
  
  func productList(
    pageNumber: Int,
    itemsPerPage: Int,
    completion: @escaping (Result<ProductList, NetworkError>) -> Void
  ) {
    guard let url = URLGenerator.productListURL(
      pageNumber: pageNumber,
      itemsPerPage: itemsPerPage
    ) else {
      return
    }
    let request = URLRequest(url: url, httpMethod: .get)
    
    let dataTask = urlSession.dataTask(request) { response in
      switch response {
      case .success(let data):
        let result = jsonParser.decode(data: data, type: ProductList.self)
        switch result {
        case .success(let data):
          completion(.success(data))
        case .failure(_):
          completion(.failure(.decodeFailed))
        }
      case .failure(_):
        completion(.failure(.responseFailed))
      }
    }
    dataTask.resume()
  }
  
  func detailProduct(
    productId: Int,
    completion: @escaping (Result<Product, NetworkError>) -> Void
  ) {
    guard let url = URLGenerator.productDetailURL(productId: productId) else {
      return
    }
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
        completion(.failure(.responseFailed))
      }
    }
    dataTask.resume()
  }
  
  func registerProduct(
    params: ProductRequestForRegistration,
    images: [UIImage],
    identifier: String,
    completion: @escaping (Result<Product, NetworkError>) -> Void
  ) {
    guard let url = URLGenerator.productAdditionURL() else {
      return
    }
    var request = URLRequest(url: url, httpMethod: .post)
    let boundary = UUID().uuidString
    let json = jsonParser.encode(data: params)
    request.addHeader(
      values: [
        "identifier": "\(identifier)",
        "Content-Type": "multipart/form-data; boundary=\(boundary)"
      ]
    )
    request.httpBody = createBody(json: json, images: images, boundary: boundary)
    
    let dataTask = urlSession.dataTask(request) { response in
      switch response {
      case .success(let data):
        let result = jsonParser.decode(data: data, type: Product.self)
        switch result {
        case .success(let data):
          completion(.success(data))
        case .failure(_):
          completion(.failure(.responseFailed))
        }
      case .failure(_):
        completion(.failure(.responseFailed))
      }
    }
    dataTask.resume()
  }
  
  func modifyProduct(
    productId: Int,
    params: ProductRequestForModification,
    identifier: String,
    completion: @escaping (Result<Product, NetworkError>) -> Void
  ) {
    guard let url = URLGenerator.productModificationURL(productId: productId) else {
      return
    }
    var request = URLRequest(url: url, httpMethod: .patch)
    let json = jsonParser.encode(data: params)
    request.addHeader(
      values: [
        "identifier": "\(identifier)"
      ]
    )
    switch json {
    case .success(let data):
      request.httpBody = data
    case .failure(_):
      completion(.failure(.encodeFailed))
    }
    
    let dataTask = urlSession.dataTask(request) { response in
      switch response {
      case .success(let data):
        let result = jsonParser.decode(data: data, type: Product.self)
        switch result {
        case .success(let data):
          completion(.success(data))
        case .failure(_):
          completion(.failure(.responseFailed))
        }
      case .failure(_):
        completion(.failure(.responseFailed))
      }
    }
    dataTask.resume()
  }
  
  func getDeleteSecret(
    productId: Int,
    secret: String,
    identifier: String,
    completion: @escaping (Result<String, NetworkError>) -> Void
  ) {
    guard let url = URLGenerator.getDeleteProductSecretURL(productId: productId) else {
      return
    }
    var request = URLRequest(url: url, httpMethod: .post)
    request.addHeader(
      values: [
        "identifier": "\(identifier)",
        "Content-Type": "application/json"
      ]
    )
    let json = jsonParser.encode(data: secret)
    switch json {
    case .success(let data):
      dump(data)
      request.httpBody = data
    case .failure(_):
      completion(.failure(NetworkError.encodeFailed))
    }
    
    let dataTask = urlSession.dataTask(request) { response in
      switch response {
      case .success(let data):
        if let string = String(data: data, encoding: .utf8) {
          dump(string)
          completion(.success(string))
        }
      case .failure(_):
        completion(.failure(.responseFailed))
      }
    }
    dataTask.resume()
  }
  
  func deleteProduct(
    productId: Int,
    productSecret: String,
    identifier: String,
    completion: @escaping (Result<Product, NetworkError>) -> Void
  ) {
    guard let url = URLGenerator.getDeleteProductURL(productId: productId, productSecret: productSecret) else {
      return
    }
    var request = URLRequest(url: url, httpMethod: .delete)
    request.addHeader(
      values: [
        "identifier": "\(identifier)",
      ]
    )
    let dataTask = urlSession.dataTask(request) { response in
      switch response {
      case .success(let data):
        let result = jsonParser.decode(data: data, type: Product.self)
        switch result {
        case .success(let data):
          completion(.success(data))
        case .failure(_):
          completion(.failure(.responseFailed))
        }
      case .failure(_):
        completion(.failure(.responseFailed))
      }
    }
    dataTask.resume()
  }
  
  func requestProductImage(
    url: String,
    completion: @escaping (Result<Data, NetworkError>) -> Void
  ) {
    guard let imageUrl = URL(string: url) else {
      return
    }
    let request = URLRequest(url: imageUrl)
    let dataTask = urlSession.dataTask(request) { response in
      switch response {
      case .success(let data):
        completion(.success(data))
      case .failure(let error):
        completion(.failure(error))
      }
    }
    dataTask.resume()
  }
}
