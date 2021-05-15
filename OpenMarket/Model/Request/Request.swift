//
//  ItemForm.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/10.
//

import Foundation

struct Request: Codable, Equatable {
    var path: String?
    var httpMethod: HTTPMethod?

    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [String]?
    var password: String?

    private enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }

    init(path: String?,
         httpMethod: HTTPMethod?,
         title: String?,
         descriptions: String?,
         price: Int?,
         currency: String?,
         stock: Int?,
         discountedPrice: Int?,
         images: [String]?,
         password: String?) throws {

        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
        self.password = password

        guard let path = path, let httpMethod = httpMethod, checkValidation(path: path, httpMethod: httpMethod) else {
            throw EncodingError.invalidParameter
        }
    }

    func checkValidation(path: String, httpMethod: HTTPMethod) -> Bool {
        switch httpMethod {
        case HTTPMethod.POST:
            return checkPathOfPost(path: path)
        case HTTPMethod.PATCH:
            return checkPathOfPatch(path: path)
        case HTTPMethod.DELETE:
            return checkPathOfDelete(path: path)
        default:
            return false
        }
    }

    func checkPathOfPatch(path: String) -> Bool {
        switch path {
        case Path.Item.id:
            guard let _ = password else {
                return false
            }
            return true
        default:
            return false
        }
    }

    func checkPathOfPost(path: String) -> Bool {
        switch path {
        case Path.item:
            guard let _ = title, let _ = descriptions, let _ = price, let _ = currency, let _ = stock, let _ = discountedPrice, let _ = images, let _ = password else {
                return false
            }
            return true
        default:
            return false
        }
    }

    func checkPathOfDelete(path: String) -> Bool {
        switch path {
        case Path.Item.id:
            guard let _ = password else {
                return false
            }
            return true
        default:
            return false
        }
    }
    
}
