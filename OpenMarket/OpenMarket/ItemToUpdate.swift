//
//  ItemToPost.swift
//  OpenMarket
//
//  Created by 이학주 on 2021/01/29.
//

import Foundation
import UIKit.UIImage

struct ItemToUpdate {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [UIImage]?
    let password: String
    
    func makeParameters() -> [String: String] {
        var parameters = [String: String]()
        
        if let title = title {
            parameters.updateValue(title, forKey: "title")
        }
        
        if let descriptions = descriptions {
            parameters.updateValue(descriptions, forKey: "descriptions")
        }
        
        if let price = price {
            parameters.updateValue(String(price), forKey: "price")
        }
        
        if let currency = currency {
            parameters.updateValue(currency, forKey: "currency")
        }
        
        if let stock = stock {
            parameters.updateValue(String(stock), forKey: "stock")
        }
        
        if let discountedPrice = discountedPrice {
            parameters.updateValue(String(discountedPrice), forKey: "title")
        }
    
        parameters.updateValue(password, forKey: "password")
        
        return parameters
    }
    
    func makeImageListToUpload() -> [ImageInfo]? {
        guard let images = images else {
            return nil
        }
        
        var imageListToUpload = [ImageInfo]()
        let mimeType = "image/jpg"
        let imageKey = "image"
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 1) {
                let image = ImageInfo(imageData: imageData, fileName: "odong\(index + 1).jpg", mimeType: mimeType, imageKey: imageKey)
                imageListToUpload.append(image)
            }
        }
        
        return imageListToUpload
    }
}

struct ImageInfo {
    let imageData: Data
    let fileName: String
    let mimeType: String
    let imageKey: String
}
