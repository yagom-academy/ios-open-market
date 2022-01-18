import Foundation

enum NetworkingError: String, Error {
    case URLRequestMakingFail
    case receivedInvalidData
    case receivedIinvalidResponse
    case receivedFailureStatusCode
}
