//
//  Product.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/14.
//
import Foundation

enum Currency: String, Codable {
    case KRW = "KRW"
    case USD = "USD"
}

struct Product: Codable, Hashable {
    let identifier = UUID()
    
    let id: Int?
    let vendorId: Int?
    let vendorName: String?
    let name: String
    let description: String
    let thumbnail: String?
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: Date?
    let issuedAt: Date?
    let images: [Image]?
    let vendor: Vendor?
    let secret: String?
    
    init(id: Int? = nil, vendorId: Int? = nil, vendorName: String? = nil, name: String, description: String, thumbnail: String? = nil, currency: Currency, price: Double, bargainPrice: Double, discountedPrice: Double, stock: Int, createdAt: Date?  = nil, issuedAt: Date?  = nil, images: [Image]? = nil, vendor: Vendor?  = nil, secret: String) {
        self.id = id
        self.vendorId = vendorId
        self.vendorName = vendorName
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.currency = currency
        self.price = price
        self.bargainPrice = bargainPrice
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.createdAt = createdAt
        self.issuedAt = issuedAt
        self.images = images
        self.vendor = vendor
        self.secret = secret
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorId = "vendor_id"
        case vendorName
        case name
        case description
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images
        case vendor = "vendors"
        case secret
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
