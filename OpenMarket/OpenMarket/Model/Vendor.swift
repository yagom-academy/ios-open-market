import Foundation

struct Vendor: Decodable {
    var name: String
    var id: Int
    var createdAt: Date
    var issuedAt: Date
}
