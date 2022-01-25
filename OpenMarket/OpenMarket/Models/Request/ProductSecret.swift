import Foundation

struct ProductSecret: Codable {
    let secret: String
    
    enum CodingKeys: CodingKey {
        case secret
    }
}
