//
//  NetworkService.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/11.
//

import Foundation

protocol NetworkService {
  func checkHealth(_ completion: (Result<String, APINetworkError>) -> Void)
  func fetchProductAll(_ completion: (Result<[Product], APINetworkError>) -> Void)
  func fetchProductOne(productID: Int, _ completion: (Result<Product, APINetworkError>) -> Void)
}
