//
//  PatchingItem.swift
//  OpenMarket
//
//  Created by Neph on 2021/05/12.
//

import Foundation

struct PatchingItem: Encodable {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String

    var textFields: [String: String?] {
        let fields: [String: String?] = ["": ""]

        return fields
    }

    var fileFields: [Data] {
        let fields: [Data] = []
        return fields
    }
}
