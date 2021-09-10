//
//  Item.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import UIKit

struct Item: Decodable {
    let id: Int
    let title: String
    let descriptions: String?
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let images: [String]?
    let registrationDate: TimeInterval

    enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }

    func image(completion: @escaping (UIImage) -> Void) {
        let cacheKey = NSString(string: id.description)
        let titleThumbnail = thumbnails[0]
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            completion(cachedImage)
        } else {
            NetworkManager().downloadImage(from: titleThumbnail) { image in
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                completion(image)
            }
        }
    }
}
