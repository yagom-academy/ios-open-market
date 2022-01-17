import Foundation

struct ProductImage: Codable, Hashable {
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
