//
//  ProductRequest.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/26.
//

import UIKit

struct ProductRequest {
  let name: String
  let price: String
  let currency: Product.Currency
  let discountedPrice: String
  let stock: String
  let description: String
  let images: [UIImage]
}
