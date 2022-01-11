import Foundation

enum NetworkingError: Error {
    case request
    case response
    case data
    case decoding
    case encoding
}
