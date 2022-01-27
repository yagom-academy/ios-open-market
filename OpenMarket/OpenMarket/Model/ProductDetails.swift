//
//  ProductDetails.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/27.
//

import Foundation

struct ProductDetails: Decodable {
    let id: Int
    let vendorID: Int
    let name: String
    let thumbnailURL: String
    let currency: String
    let price: Double
    let description: String
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    let images: [ImageData]
    let vendors: VendorData

    enum CodingKeys: String, CodingKey {
        case id, name, description, currency, price, stock, images, vendors
        case vendorID = "vendor_id"
        case thumbnailURL = "thumbnail"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
    
    struct ImageData: Decodable {
        let id: Int
        let url: String
        let thumbnailURL: String
        let succeed: Bool
        let issuedAt: String
        
        enum CodingKeys: String, CodingKey {
            case id, url, succeed
            case thumbnailURL = "thumbnail_url"
            case issuedAt = "issued_at"
        }
    }

    struct VendorData: Decodable {
        let name: String
        let id: Int
        let createdAt: String
        let issuedAt: String
        
        enum CodingKeys: String, CodingKey {
            case name, id
            case createdAt = "created_at"
            case issuedAt = "issued_at"
        }
    }
}



/**
 
 "images": [
     {
         "id": 352,
         "url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/origin/f9aa6e0d787711ecabfa3f1efeb4842b.jpg",
         "thumbnail_url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/f9aa6e0d787711ecabfa3f1efeb4842b.jpg",
         "succeed": true,
         "issued_at": "2022-01-18T00:00:00.00"
     }
 ],
 "vendors": {
     "name": "제인",
     "id": 6,
     "created_at": "2022-01-10T00:00:00.00",
     "issued_at": "2022-01-10T00:00:00.00"
 }
 */
