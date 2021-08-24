//
//  ItemData.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/10.
//

import UIKit
enum StockAmount: Int {
    case Maximum = 9999
}

struct ItemData: Codable, Equatable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: TimeInterval
    let descriptions: String?
    let images: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case thumbnails
        case registrationDate = "registration_date"
        case descriptions
        case images
    }
    
    func image(completion: @escaping (UIImage) -> Void) {
        let cacheKey = NSString(string: id.description)
        if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
            completion(cachedImage)
        } else {
            NetworkManager().downloadImage(from: thumbnails[0]) { image in
                ImageCache.shared.setObject(image, forKey: cacheKey)
                completion(image)
            }
        }
    }
}
