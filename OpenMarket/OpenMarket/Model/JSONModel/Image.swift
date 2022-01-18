import Foundation

struct Image: Codable, Hashable {
    let id: Int
    let url, thumbnailURL: String
    let succeed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailURL = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}
