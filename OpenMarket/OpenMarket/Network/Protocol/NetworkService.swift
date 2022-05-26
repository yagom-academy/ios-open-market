//
//  NetworkService.swift
//  OpenMarket
//  Created by Lingo, Quokka on 2022/05/11.
//

import UIKit

protocol NetworkService {
  func checkHealth(
    _ completion: @escaping (Result<String, APINetworkError>) -> Void
  )
  
  func fetchProductAll(
    pageNumber: Int,
    itemsPerPage: Int,
    _ completion: @escaping (Result<[Product], APINetworkError>) -> Void
  )
  
  func fetchProductOne(
    productID: Int,
    _ completion: @escaping (Result<Product, APINetworkError>) -> Void
  )
  
  func registerProduct(_ product: ProductRequest)
}
