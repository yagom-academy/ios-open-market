//
//  OpenMarketItems.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/13.
//

import Foundation

struct ListSearchResponse: ListSearchable {
  let page: Int
  let itmes: [Item]

  struct Item: InfoSearchable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: Double

    enum CodingKeys: String, CodingKey {
      case id, title, price, currency, stock, thumbnails
      case discountedPrice = "discounted_price"
      case registrationDate = "registration_date"
    }
  }
}
