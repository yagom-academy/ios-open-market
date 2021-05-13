//
//  상품등록request.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/13.
//

import Foundation

struct 상품등록request: Encodable {
  let title: String
  let description: String
  let price: Int
  let currency: String
  let stock: Int
  let discountedPrice: Int?
  let images: [String]
  let password: String
  
  enum CodingKeys: String, CodingKey {
    case title, description, price, currency, stock, images, password
    case discountedPrice = "discounted_price"
  }
}
