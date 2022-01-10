import Foundation

enum URLSessionError: LocalizedError, Equatable {
    case requestFailed(description: String)
    case responseFailed(code: Int)
    case invaildData
}
