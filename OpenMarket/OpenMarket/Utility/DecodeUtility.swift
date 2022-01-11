import Foundation

enum DecodeUtility {
    static func decode<Type: Decodable>(data: Data) throws -> Type {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.openMarket)
        guard let result: Type = try? decoder.decode(Type.self, from: data) else {
            throw NetworkingError.decoding
        }
        return result
    }
}

extension DateFormatter {
    static let openMarket: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
