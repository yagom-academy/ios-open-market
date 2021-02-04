//
//  GoodsForm.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation
import UIKit

protocol MakeForm {
    func makeRegisterForm() throws -> [String : Any]
    func makeEditForm() -> [String : Any]
    func makeDeleteForm() throws -> [String : Any]
}

protocol ConvertMultipartForm {
    static func makeBodyData(with parameter: [String : Any], boundary: String) -> Data
}

struct GoodsForm {
    let password: String
    var id: UInt? = nil
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [UIImage]?
    
    init(registerPassword: String,
         title: String,
         descriptions: String,
         price: Int,
         currency: String,
         stock: Int,
         discountedPrice: Int?,
         images: [UIImage]) {
        self.password = registerPassword
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
    }
    
    init(editPassword: String,
         title: String?,
         descriptions: String?,
         price: Int?,
         currency: String?,
         stock: Int?,
         discountedPrice: Int?,
         images: [UIImage]?) {
        self.password = editPassword
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
    }
    
    init(deletePassword: String,
         id: UInt) {
        self.password = deletePassword
        self.id = id
        self.title = nil
        self.descriptions = nil
        self.price = nil
        self.currency = nil
        self.stock = nil
        self.discountedPrice = nil
        self.images = nil
    }
}

extension GoodsForm: MakeForm {
    func makeRegisterForm() throws -> [String : Any] {
        guard let title = self.title,
              let descriptions = self.descriptions,
              let price = self.price,
              let currency = self.currency,
              let stock = self.stock,
              let images = self.images else {
            throw OpenMarketError.shortageForm
        }
        var parameter: [String : Any] = [:]
        parameter["password"] = password
        parameter["title"] = title
        parameter["descriptions"] = descriptions
        parameter["price"] = price
        parameter["currency"] = currency
        parameter["stock"] = stock
        
        let imagesData = images.map { $0.pngData() }
        parameter["images"] = imagesData
        if let discountedPrice = discountedPrice  {
            parameter["discounted_price"] = discountedPrice
        }
        
        return parameter
    }
    
    func makeEditForm() -> [String : Any] {
        var parameter: [String : Any] = [:]
        parameter["password"] = password
        if let title = title {
            parameter["title"] = title
        }
        if let descriptions = descriptions {
            parameter["descriptions"] = descriptions
        }
        if let price = price {
            parameter["price"] = price
        }
        if let currency = currency {
            parameter["currency"] = currency
        }
        if let stock = stock {
            parameter["stock"] = stock
        }
        if let discountedPrice = discountedPrice {
            parameter["discounted_price"] = discountedPrice
        }
        if let images = images {
            let imagesData = images.map { $0.jpegData(compressionQuality: 1.0) }.compactMap { $0 }
            parameter["images"] = imagesData
        }
        
        return parameter
    }
    
    func makeDeleteForm() throws -> [String : Any] {
        guard let id = self.id else {
            throw OpenMarketError.shortageForm
        }
        var parameter: [String : Any] = [:]
        parameter["id"] = id
        parameter["password"] = password
        
        return parameter
    }
}

extension GoodsForm: ConvertMultipartForm {
    static func makeBodyData(with parameter: [String : Any], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameter {
            if let data = value as? [Data] {
                body.append(makeMultiformParameter(key: key, value: data, boundary: boundary))
            } else {
                body.append(makeMultiformParameter(key: key, value: value, boundary: boundary))
            }
        }
        
        let lastBoundaryLine = "--\(boundary)--\r\n"
        body.append(lastBoundaryLine)

        return body
    }
    
    static private func makeMultiformParameter(key: String, value: [Data], boundary: String) -> Data {
        var body = Data()
        var filename = String()
        for (index, image) in value.enumerated() {
            filename = "image\(index).png"
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)[]\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: image/png\r\n\r\n")
            body.append(image)
            body.append("\r\n")
        }
        
        return body
    }
    
    static private func makeMultiformParameter(key: String, value: Any, boundary: String) -> Data {
        var body = Data()

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        if let data = value as? String {
            body.append(data)
        } else if let data = value as? Int {
            body.append(String(data))
        }
        body.append("\r\n")

        return body
    }
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
