import Foundation

struct Image: Decodable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let isSuccess: Bool
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case isSuccess = "succeed"
        case id, url, thumbnailUrl, issuedAt
    }
}
