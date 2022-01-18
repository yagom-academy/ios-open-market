import Foundation

struct Vendors: Codable, Hashable {
    let name: String
    let id: Int
    let createdAt, issuedAt: String

    enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
