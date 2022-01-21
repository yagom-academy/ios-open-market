//
//  RegisterProductRequest.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/18.
//

import Foundation

/**
 상품 등록의 모델 타입 (Request)
*/
struct ProductRequestForModification: Encodable {
  let name: String
  let descriptions: String
  let thumbnailId: Int?
  let price: Double
  let currency: Currency
  let discountedPrice: Double?
  let stock: Int?
  let secret: String
  
  init(
    name: String,
    descriptions: String,
    thumbnailId: Int?,
    price: Double,
    currency: Currency,
    discountedPrice: Double?,
    stock: Int?,
    secret: String
  ) {
    self.name = name
    self.descriptions = descriptions
    self.thumbnailId = thumbnailId
    self.price = price
    self.currency = currency
    self.discountedPrice = discountedPrice
    self.stock = stock
    self.secret = secret
  }
  
  enum CodingKeys: String, CodingKey {
    case name
    case descriptions
    case price
    case currency
    case discountedPrice = "discounted_price"
    case stock
    case secret
  }
}

