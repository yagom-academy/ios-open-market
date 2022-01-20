import Foundation

enum NetworkingAPIError: String, Error {
    case URLRequestMakingFail
    case receivedInvalidData
    case receivedIinvalidResponse
    case receivedFailureStatusCode
    case HTTPBodyMakingFail
    case typeConversionFail
}
