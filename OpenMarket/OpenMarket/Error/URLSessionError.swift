import Foundation

enum URLSessionError: LocalizedError, Equatable {
    case requestFailed
    case responseFailed(code: Int)
    case invaildData
}
