//
//  InfoSearchable.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/13.
//

import Foundation

protocol InfoSearchable: Decodable {
  var id: Int { get }
  var title: String { get }
  var price: Int { get }
  var currency: String { get }
  var stock: Int { get }
  var discountedPrice: Int? { get }
  var thumbnails: [String] { get }
  var registrationDate: Double { get }
}
