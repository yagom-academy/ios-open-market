//
//  modifyProductRequest.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/18.
//

import Foundation

struct ProductModificationRequest: Encodable {
  let name: String?
  let descriptions: String?
  let thumnailId: Int?
  let price: Double?
  let currency: Currency?
  let discountedPrice: Double?
  let stock: Int?
  let secret: String
  
  init(name: String? = nil, descriptions: String? = nil, thumnailId: Int? = nil, price: Double? = nil, currency: Currency? = nil, discountedPrice: Double? = nil, stock: Int? = nil, secret: String) {
    self.name = name
    self.descriptions = descriptions
    self.thumnailId = thumnailId
    self.price = price
    self.currency = currency
    self.discountedPrice = discountedPrice
    self.stock = stock
    self.secret = secret
  }
  
  enum CodingKeys: String, CodingKey {
    case name
    case descriptions
    case thumnailId = "thumnail_id"
    case price
    case currency
    case discountedPrice = "discounted_price"
    case stock
    case secret
  }
}

