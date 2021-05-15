//
//  ItemForm.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/10.
//

import Foundation

struct Request: Codable, Equatable {
    var path: String?
    var httpMethod: String?
    
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [String]?
    var password: String?

    private enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
    }
    
    init() throws {
        guard let path = path, let httpMethod = httpMethod, checkValidation(path: path, httpMethod: httpMethod) else {
            throw EncodingError.invalidParameter
        }
    }
    
    func checkValidation(path: String, httpMethod: String) -> Bool {
        switch httpMethod {
        case "POST":
            return checkPathOfPost(path: path)
        case "PATCH":
            return checkPathOfPatch(path: path)
        case "DELETE":
            return checkPathOfDelete(path: path)
        default:
            return false
        }
    }
    
    func checkPathOfPatch(path: String) -> Bool {
        switch path {
        case "/Item/:id":
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
        case "/Item" :
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
        case "/Item:id" :
            guard let _ = password else {
                return false
            }
            return true
        default:
            return false
        }
    }
    
}
