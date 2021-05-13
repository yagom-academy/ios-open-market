//
//  상품등록response.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/13.
//

import Foundation

struct 상품등록response: Decodable {
  let id: Int
  let title: String
  let description: String
  let price: Int
  let currency: String
  let stock: Int
  let discountedPrice: Int?
  let thumbnails: [String]
  let images: [String]
  let registrationDate: Double
  
  enum CodingKeys: String, CodingKey {
    case id, title, description, price, currency, stock, thumbnails, images
    case discountedPrice = "discounted_price"
    case registrationDate = "registration_date"
  }
}
