//
//  ResponsedPage.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/12.
//

import Foundation
import UIKit

struct ResponsedPage: Decodable {
    let page: Int
    let items: [ResponsedPage.Item]

    struct Item: Decodable {
        let id: Int
        let title: String
        let price: Int
        let currency: String
        let stock: Int
        let discountedPrice: Int?
        let thumbnails: [String]
        let registrationDate: TimeInterval

        private enum CodingKeys: String, CodingKey {
            case id, title, price, currency, stock, thumbnails
            case discountedPrice = "discounted_price"
            case registrationDate = "registration_date"
        }

        func toPageItem() -> Page.Item? {
            var thumbnails: [UIImage] = []
            let date = Date(timeIntervalSince1970: registrationDate)

            for url in self.thumbnails {
                guard let image = UIImage.fetchImageFromURL(url: url) else { return nil }
                thumbnails.append(image)
            }

            return Page.Item(id: id,
                             title: title,
                             price: price,
                             currency: currency,
                             stock: stock,
                             discountedPrice: discountedPrice,
                             thumbnails: thumbnails,
                             registrationDate: date)
        }
    }
}
