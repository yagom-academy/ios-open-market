//
//  GetItem.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/13.
//

import Foundation

struct PostItem: Codable {
  var title: String
  var descriptions: String
  var price: Int
  var currency: String
  var stock: Int
  var discountedPrice: Int?
  var images: [Data]
  var password: String
  
  
  enum CodingKeys: String, CodingKey {
    case title
    case descriptions
    case price
    case currency
    case discountedPrice = "discounted_price"
    case stock
    case images
    case password
  }
}
