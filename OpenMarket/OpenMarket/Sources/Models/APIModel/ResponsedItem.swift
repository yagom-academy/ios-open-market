//
//  ResponsedItem.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/12.
//

import Foundation
import UIKit

struct ResponsedItem: Decodable {
    let id: Int
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]
    let registrationDate: TimeInterval

    private enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }

    func toItem() -> Item? {
        var images: [UIImage] = []
        var thumbnails: [UIImage] = []
        let date = Date(timeIntervalSince1970: registrationDate)

        for url in self.images {
            guard let image = UIImage.fetchImageFromURL(url: url) else { return nil }
            images.append(image)
        }

        for url in self.thumbnails {
            guard let image = UIImage.fetchImageFromURL(url: url) else { return nil }
            thumbnails.append(image)
        }

        return Item(id: id,
                    title: title,
                    descriptions: descriptions,
                    price: price,
                    currency: currency,
                    stock: stock,
                    discountedPrice: discountedPrice,
                    thumbnails: thumbnails,
                    images: images,
                    registrationData: date)
    }
}
