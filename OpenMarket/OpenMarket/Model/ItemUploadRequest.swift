//
//  ItemUploadRequest.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation
import UIKit

struct ItemUploadRequest: Encodable {
    let title: String?
    let descriptions: String?
    let price: UInt?
    let currency: String?
    let stock: UInt?
    let discountedPrice: UInt?
    let images: [String]?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, images, stock, password
        case discountedPrice = "discounted_price"
    }
}
