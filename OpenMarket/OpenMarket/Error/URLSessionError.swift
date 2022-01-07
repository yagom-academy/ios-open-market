import Foundation

enum URLSessionError: LocalizedError {
    case requestFailed
    case responseFailed(code: Int)
    case invaildData
}
