import Foundation

struct Product: Codable {
    var id: Int
    var vendorId: Int
    var name: String
    var thumbnail: String
    var currency: Currency
    var price: Int
    var bargainPrice: Int
    var discountedPrice: Int
    var stock: Int
    var createdAt: Date
    var issuedAt: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Self.CodingKeys)
        id = try container.decode(Int.self, forKey: .id)
        vendorId = try container.decode(Int.self, forKey: .vendorId)
        name = try container.decode(String.self, forKey: .name)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        currency = try container.decode(Currency.self, forKey: .currency)
        price = try container.decode(Int.self, forKey: .price)
        bargainPrice = try container.decode(Int.self, forKey: .bargainPrice)
        discountedPrice = try container.decode(Int.self, forKey: .discountedPrice)
        stock = try container.decode(Int.self, forKey: .stock)
        
        let createdAt = try container.decode(String.self, forKey: .createdAt)
        let issuedAt = try container.decode(String.self, forKey: .issuedAt)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        guard let formattedCreatedAt = formatter.date(from: createdAt),
              let formattedIssuedAt = formatter.date(from: issuedAt) else {
                  throw FormattingError.dateFormattingFail
              }
        self.issuedAt = formattedIssuedAt
        self.createdAt = formattedCreatedAt
    }
}
