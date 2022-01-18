//
//  Product.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/03.
//

import Foundation

enum Currency: String, Codable {
  case KRW
  case USD
}

extension Currency: Hashable { }

/**
 상품 정보의 모델타입입니다.
*/
struct Product: Codable {
  /// 상품 ID
  let id: Int
  /// 상품 판매자의 ID
  let venderId: Int
  /// 상품 이름
  let name: String
  /// 상품의 썸네일 이미지 URL
  let thumbnail: String
  /// 상품의 거래 통화
  let currency: Currency
  /// 상품의 정가
  var price: Double
  /// 상품의 할인 가격
  let bargainPrice: Double
  /// 할인된 가격
  let discountedPrice: Double
  /// 상품의 재고
  let stock: Int
  /// 상품의 이미지 URL의 배열
  let images: [Image]?
  /// 판매자의 정보
  let vendor: Vendor?
  let createdAt: String
  let issuedAt: String
  
  var formattedFixedPrice: String {
    let formattedPrice = PresentStyle.formatNumber(price)
    return "\(currency.rawValue) \(formattedPrice)"
  }
  
  var formattedBargainPrice: String {
    let formattedBargainPrice = PresentStyle.formatNumber(bargainPrice)
    return "\(currency.rawValue) \(formattedBargainPrice)"
  }
  
  var formattedStock: String {
    if stock == 0 {
      return "품절"
    }
    let formattedStock = PresentStyle.formatNumber(stock)
    return "잔여수량: \(formattedStock)"
  }
  
  enum CodingKeys: String, CodingKey {
    case id, name, thumbnail, currency, price, stock, images
    case vendor = "vendors"
    case venderId = "vendor_id"
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}

extension Product: Hashable { }

