import Foundation

struct Vendor: Decodable {
    let name: String
    let id: Int
    let createdAt: Date
    let issuedAt: Date
}
