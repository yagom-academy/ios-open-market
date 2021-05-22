//
//  ProductRegisterRequest.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/13.
//

import Foundation

struct ProductRegisterRequest: Encodable {
  let title: String
  let descriptions: String
  let price: Int
  let currency: String
  let stock: Int
  let discountedPrice: Int?
  let images: [Data]
  let password: String
  
  private enum CodingKeys: String, CodingKey {
    case title, descriptions, price, currency, stock, images, password
    case discountedPrice = "discounted_price"
  }
}

extension ProductRegisterRequest: Uploadable {
  var parameters: [String: Any?] {
    ["title":title,
     "descriptions":descriptions,
     "price":price,
     "currency":currency,
     "stock":stock,
     "discounted_price":discountedPrice,
     "images":images,
     "paswword":password]
  }
}
