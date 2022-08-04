//
//  EnrollProductEntity.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

struct EnrollProductEntity {
    let parameter: PostParameter
    let images: [ProductImage]
}

struct PostParameter {
    let name: String
    let descriptions: String
    let price: Int
    let currency: Currency
    let discounted_price: Int?
    let stock: Int?
    let secret: String
    
    init(name: String,
         descriptions: String,
         price: Int,
         currency: Currency,
         discounted_price: Int? = 0,
         stock: Int? = 0,
         secret: String) {
        
        self.name = name
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.discounted_price = discounted_price
        self.stock = stock
        self.secret = secret
    }
    
    func returnValue() -> Data {
        var dicValue = [String : String]()
        dicValue["name"] = "\(name)"
        dicValue["price"] = "\(price)"
        dicValue["currency"] = "\(currency.rawValue)"
        dicValue["secret"] = "\(secret)"
        dicValue["descriptions"] = "\(descriptions)"
        
        if let discounted_price = discounted_price {
            dicValue["discounted_price"] = "\(discounted_price)"
        }
        
        if let stock = stock {
            dicValue["stock"] = "\(stock)"
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dicValue,
                                                  options: [])
            return data
        } catch {
            return Data()
        }
    }
}

struct ProductImage {
    let fileName: String
    let data: Data
    let mimeType: MIMEType
    
    init?(withImage image: UIImage) {
        self.mimeType = MIMEType.imageJPEG
        self.fileName = "image\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        self.data = data
    }
}
