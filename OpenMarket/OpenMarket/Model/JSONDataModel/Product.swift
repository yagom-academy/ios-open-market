//
//  Product.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/14.
//

struct Product: Hashable {
    let id, vendorID: Int
    let name, thumbnail: String
    let description: String?
    let currency: Currency
    let price, bargainPrice, discountedPrice: Double
    let stock: Int
    let createdAt, issuedAt: String
    let images: [ProductImage]?
    let vendor: Vendor?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, description, thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images
        case vendor = "vendors"
        case secret
    }
    
    init(id: Int = 0, vendorID: Int = 0, name: String, thumbnail: String = "", description: String? = nil, currency: Currency, price: Double, bargainPrice: Double = 0, discountedPrice: Double = 0, stock: Int = 0, createdAt: String = "", issuedAt: String = "", images: [ProductImage]? = nil, vendor: Vendor? = nil) {
        self.id = id
        self.vendorID = vendorID
        self.name = name
        self.thumbnail = thumbnail
        self.description = description
        self.currency = currency
        self.price = price
        self.bargainPrice = bargainPrice
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.createdAt = createdAt
        self.issuedAt = issuedAt
        self.images = images
        self.vendor = vendor
    }
}

extension Product: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.vendorID = try container.decode(Int.self, forKey: .vendorID)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        self.currency = try container.decode(Currency.self, forKey: .currency)
        self.price = try container.decode(Double.self, forKey: .price)
        self.bargainPrice = try container.decode(Double.self, forKey: .bargainPrice)
        self.discountedPrice = try container.decode(Double.self, forKey: .discountedPrice)
        self.stock = try container.decode(Int.self, forKey: .stock)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.issuedAt = try container.decode(String.self, forKey: .issuedAt)
        self.images = try container.decodeIfPresent([ProductImage].self, forKey: .images)
        self.vendor = try container.decodeIfPresent(Vendor.self, forKey: .vendor)
    }
}

extension Product: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.currency, forKey: .currency)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.discountedPrice, forKey: .discountedPrice)
        try container.encode(self.stock, forKey: .stock)
        try container.encode("xwxdkq8efjf3947z", forKey: .secret)
    }
}
