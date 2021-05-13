//
//  Registratable.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/13.
//

import Foundation

protocol Registratable: Authenticatable {
  var title: String { get }
  var description: String { get }
  var price: Int { get }
  var currency: String { get }
  var stock: Int { get }
  var discountedPrice: Int? { get }
  var images: [Data] { get }
}
