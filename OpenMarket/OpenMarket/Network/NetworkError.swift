import Foundation

enum NetworkError: Error {
    case statusCodeError
    case emptyValue
    case parsingFailed
    case wrongURL
}
