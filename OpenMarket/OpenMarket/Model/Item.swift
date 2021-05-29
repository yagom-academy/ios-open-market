//
//  Item.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/11.
//

import Foundation

struct Item: Codable, Equatable, Hashable, MultipartTypeConverter {
    let id: Int?
    let title: String?
    let descriptions: String?
    let currency: String?
    let price: Int?
    let discountedPrice: Int?
    let stock: Int?
    let thumbnails: [String]?
    let imagesFiles: [Data]?
    let images: [String]?
    let password: String?
    let registrationDate: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, descriptions, currency, price, stock, thumbnails, imagesFiles, images, password
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
    
    init(forGetID id: Int,
         title: String,
         currency: String,
         price: Int,
         discountedPrice: Int?,
         stock: Int,
         thumbnails: [String],
         registrationDate: Double) {
        self.id = id
        self.title = title
        self.currency = currency
        self.price = price
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.thumbnails = thumbnails
        self.registrationDate = registrationDate
        
        self.descriptions = nil
        self.imagesFiles = nil
        self.images = nil
        self.password = nil
    }
    
    init(forPostPassword password: String,
         title: String,
         descriptions: String,
         currency: String,
         price: Int,
         discountedPrice: Int?,
         stock: Int,
         imagesFiles: [Data]) {
        self.title = title
        self.descriptions = descriptions
        self.currency = currency
        self.price = price
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.imagesFiles = imagesFiles
        self.password = password
        
        self.id = nil
        self.images = nil
        self.thumbnails = nil
        self.registrationDate = nil
    }
    
    init(forPatchPassword password: String,
         title: String?,
         descriptions: String?,
         currency: String?,
         price: Int?,
         discountedPrice: Int?,
         stock: Int?,
         imagesFiles: [Data]?) {
        self.title = title
        self.descriptions = descriptions
        self.currency = currency
        self.price = price
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.imagesFiles = imagesFiles
        self.password = password
        
        self.id = nil
        self.images = nil
        self.thumbnails = nil
        self.registrationDate = nil
    }
    
    init(forDeletePassword password: String) {
        self.password = password
        
        self.id = nil
        self.title = nil
        self.descriptions = nil
        self.currency = nil
        self.price = nil
        self.discountedPrice = nil
        self.stock = nil
        self.imagesFiles = nil
        self.images = nil
        self.thumbnails = nil
        self.registrationDate = nil
    }
    
    init(forResponseID id: Int,
         title: String,
         descriptions: String,
         currency: String,
         price: Int,
         discountedPrice: Int?,
         stock: Int,
         thumbnails: [String],
         images: [String],
         registrationDate: Double) {
        self.id = id
        self.title = title
        self.descriptions = descriptions
        self.currency = currency
        self.price = price
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.thumbnails = thumbnails
        self.images = images
        self.registrationDate = registrationDate
        
        self.password = nil
        self.imagesFiles = nil
    }
}


