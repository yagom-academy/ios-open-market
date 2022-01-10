import Foundation

enum ParserError: LocalizedError {
    case decodeFail
}

extension ParserError {
    var description: String {
        switch self {
        case .decodeFail:
            return "JSON decoding fail"
        }
    }
}
