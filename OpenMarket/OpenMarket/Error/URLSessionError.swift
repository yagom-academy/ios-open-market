import Foundation

enum URLSessionError: LocalizedError {
    case requestFail
    case statusCodeError(Int)
    case invalidData
    case urlIsNil
}

extension URLSessionError {
    var errorDescription: String? {
        switch self {
        case .requestFail:
            return "Request has been failed"
        case .statusCodeError(let statusCode):
            return "Http status code error : \(statusCode)"
        case .invalidData:
            return "Invalid data"
        case .urlIsNil:
            return "Url is nil"
        }
    }
}
