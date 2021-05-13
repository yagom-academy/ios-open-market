//
//  상품수정request.swift
//  OpenMarket
//
//  Created by 강경 on 2021/05/13.
//

import Foundation

struct ProductUpdateRequest: Editable {    
  let title: String?
  let description: String?
  let price: Int?
  let currency: String?
  let stock: Int?
  let discountedPrice: Int?
  let images: [Data]?
  let password: String
  
  private enum CodingKeys: String, CodingKey {
    case title, description, price, currency, stock, images, password
    case discountedPrice = "discounted_price"
  }
}
