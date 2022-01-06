import Foundation

struct Image: Decodable {
    var id: Int
    var url: String
    var thumbnailUrl: String
    var isSuccess: Bool
    var issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case isSuccess = "succeed"
        case id, url, thumbnailUrl, issuedAt
    }
}
