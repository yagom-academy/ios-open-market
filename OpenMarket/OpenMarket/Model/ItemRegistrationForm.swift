//
//  ItemRegistrationForm.swift
//  OpenMarket
//
//  Created by steven on 2021/05/11.
//

import Foundation

struct ItemRegistrationForm/*: Codable*/ {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [String]?
    let password: String
    
    var multiFormData: [String: String] {
        var datas: [String: String] = [:]
        
        if let title = title {
            datas["title"] = title
        }
        
        if let descriptions = descriptions {
            datas["descriptions"] = descriptions
        }
        
        if let price = price {
            datas["price"] = String(price)
        }
        
        if let currency = currency {
            datas["currency"] = currency
        }
        
        if let stock = stock {
            datas["stock"] = String(stock)
        }
        
        if let discountedPrice = discountedPrice {
            datas["discounted_price"] = String(discountedPrice)
        }
        
        if let images = images {
            for image in images {
                datas["images[]"] = image
            }
        }
        
        datas["password"] = password
        
        return datas
    }
//    enum CodingKeys: String, CodingKey {
//        case title, descriptions, price, currency, stock, images, password
//        case discountedPrice = "discounted_price"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        title = try values.decodeIfPresent(String.self, forKey: .title)
//        descriptions = try values.decodeIfPresent(String.self, forKey: .descriptions)
//        price = try values.decodeIfPresent(Int.self, forKey: .price)
//        currency = try values.decodeIfPresent(String.self, forKey: .currency)
//        stock = try values.decodeIfPresent(Int.self, forKey: .stock)
//        discountedPrice = try values.decodeIfPresent(Int.self, forKey: .discountedPrice)
//        images = try values.decodeIfPresent([String].self, forKey: .images)
//        password = try values.decode(String.self, forKey: .password)
//    }
}
