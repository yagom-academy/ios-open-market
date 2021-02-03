//
//  ItemToPost.swift
//  OpenMarket
//
//  Created by 임성민 on 2021/02/02.
//

import UIKit

typealias ItemToPatch = ItemToPost

struct ItemToPost: MultipartFormData {
    var parameters: [String: String]? = [:]
    var medias: [Media]? = []
    
    init(title: String?, descriptions: String?, price: Int?, currency: String?, stock: Int?, discountedPrice: Int?, images: [UIImage]?, password: String) {
        if let title = title {
            parameters?.updateValue(title, forKey: "title")
        }
        if let descriptions = descriptions {
            parameters?.updateValue(descriptions, forKey: "descriptions")
        }
        if let price = price {
            parameters?.updateValue(String(price), forKey: "price")
        }
        if let currency = currency {
            parameters?.updateValue(currency, forKey: "currency")
        }
        if let stock = stock {
            parameters?.updateValue(String(stock), forKey: "stock")
        }
        if let discountedPrice = discountedPrice {
            parameters?.updateValue(String(discountedPrice), forKey: "discounted_price")
        }
        if let images = images {
            initMedias(images: images)
        }
        parameters?.updateValue(password, forKey: "password")
    }
    
    private mutating func initMedias(images: [UIImage]) {
        let mimeType = "image/jpg"
        let key = "images[]"
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 1), let media = Media(key: key, fileName: "\(index).jpg", mimeType: mimeType,  data: imageData) {
                medias?.append(media)
            }
        }
    }
}
