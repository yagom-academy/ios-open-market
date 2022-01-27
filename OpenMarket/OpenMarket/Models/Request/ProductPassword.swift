import Foundation

struct ProductPassword: Codable {
    let secret: String
    
    enum CodingKeys: CodingKey {
        case secret
    }
}
