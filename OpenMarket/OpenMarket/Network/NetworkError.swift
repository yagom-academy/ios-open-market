import Foundation

enum NetworkError: Error {
    case statusCodeError
    case unknownFailed
    case parsingFailed
}
