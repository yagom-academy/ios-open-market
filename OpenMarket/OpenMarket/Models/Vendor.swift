import Foundation

struct Vendor: Codable {
    let name: String
    let id: Int
    let createdAt: Date
    let issuedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

extension Vendor: Hashable { }
