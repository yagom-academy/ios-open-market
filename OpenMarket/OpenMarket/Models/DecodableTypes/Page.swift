struct Page: Decodable, Hashable {
    let id: Int
    let vendorId: Int
    let name: String
    let description: String?
    let thumbnail: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let images: [ProductImage]?
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case vendorId = "vendor_id"
        case name
        case description
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case images
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
