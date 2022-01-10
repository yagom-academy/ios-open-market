import Foundation

enum URLSessionError: LocalizedError {
    case requestFail
    case statusCodeError
    case invalidData
}

extension URLSessionError {
    var errorDescription: String {
        switch self {
        case .requestFail:
            return "Request has been failed"
        case .statusCodeError:
            return "Http status code error"
        case .invalidData:
            return "Invalid data"
        }
    }
}
