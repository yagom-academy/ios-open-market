//
//  OpenMarketItems.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/13.
//

import Foundation

struct 목록조회response: Codable {
  let page: Int
  let items: [Item]

  struct Item: Codable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: Int

    private enum CodingKeys: String, CodingKey {
      case id, title, price, currency, stock, thumbnails
      case discountedPrice = "discounted_price"
      case registrationDate = "registration_date"
    }
  }
}
