import Foundation

enum ParserError: LocalizedError {
    case decodeFail
}

extension ParserError {
    var errorDescription: String? {
        switch self {
        case .decodeFail:
            return "JSON decoding fail"
        }
    }
}
