import Foundation

protocol JSONResponseDecodable {
    associatedtype Response: Decodable
}

extension JSONResponseDecodable {
    static func decode(data: Data) -> Response? {
        return try? JSONDecoder().decode(Response.self, from: data)
    }
}
