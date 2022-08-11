struct ProductImage: Decodable, Hashable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let succeed: Bool
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case url
        case thumbnailUrl = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}
