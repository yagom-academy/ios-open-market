//
//  ListSearchResponse.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/13.
//

import Foundation

struct ListSearchResponse: Decodable {
  let page: Int
  let items: [Item]
  
  struct Item: Decodable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: Double
    
    private enum CodingKeys: String, CodingKey {
      case id, title, price, currency, stock, thumbnails
      case discountedPrice = "discounted_price"
      case registrationDate = "registration_date"
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
      self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
      self.price = (try? container.decode(Int.self, forKey: .price)) ?? 0
      self.currency = (try? container.decode(String.self, forKey: .currency)) ?? ""
      self.stock = (try? container.decode(Int.self, forKey: .stock)) ?? 0
      self.discountedPrice = (try? container.decode(Int?.self, forKey: .discountedPrice)) ?? 0
      self.thumbnails = (try? container.decode([String].self, forKey: .thumbnails)) ?? []
      self.registrationDate = (try? container.decode(Double.self, forKey: .registrationDate)) ?? 0.0
    }
  }
}
