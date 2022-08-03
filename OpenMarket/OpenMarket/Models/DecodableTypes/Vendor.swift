struct Vendor: Decodable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
