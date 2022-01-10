import Foundation

enum NetworkError: Error {
    case statusCodeError
    case unknownFailed
    case parsingFailed
    case wrongURL
}
