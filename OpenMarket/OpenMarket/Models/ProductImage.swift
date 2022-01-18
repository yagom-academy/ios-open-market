import Foundation

struct ProductImage: Codable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let succeed: Bool
    let issuedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, url, succeed
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}

extension ProductImage: Hashable { }
