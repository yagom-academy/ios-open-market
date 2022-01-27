import Foundation

protocol JSONResponseDecodable {
    associatedtype DecodingType: Decodable
}

extension JSONResponseDecodable {
    func decode(data: Data) -> DecodingType? {
        return try? JSONDecoder().decode(DecodingType.self, from: data)
    }
}
