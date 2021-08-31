//
//  PATCHItem.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

struct PATCHItem {
    private let title: String?
    private let descriptions: String?
    private let price: Int?
    private let currency: String?
    private let stock: Int?
    private let discounted_price: Int?
    private let images: [Media?]
    private let password: String
}
