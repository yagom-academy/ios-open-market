//
//  Page.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/12.
//

import UIKit

struct Page {
    let page: Int
    let items: [Page.Item]

    struct Item {
        let id: Int
        let title: String
        let price: Int
        let currency: String
        let stock: Int
        let discountedPrice: Int?
        let thumbnails: [UIImage]
        let registrationDate: Date
    }
}
