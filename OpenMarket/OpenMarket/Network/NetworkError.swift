import Foundation

enum NetworkError: Error {
    case statusCodeError
    case urlResponseError
    case unknownFailed
    case parsingFailed
    case wrongURL
}
