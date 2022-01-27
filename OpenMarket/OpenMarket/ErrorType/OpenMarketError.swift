import Foundation

enum OpenMarketError: Error {
    //Common Error
    case conversionFail(String, String)
    
    //Networking Error
    case URLRequestMakingFail
    case receivedInvalidData
    case receivedIinvalidResponse
    case receivedFailureStatusCode(Int)
    case HTTPBodyMakingFail

    //JSON Parsing Error
    case encodingFail(String, String)
    case decodingFail(String, String)
    
    var description: String {
        switch self {
        //Common Error
        case .conversionFail(let from, let to):
            return "typeConversionFail (from: \(from) -> to: \(to))"
            
        //Networking Error
        case .URLRequestMakingFail:
            return "URLRequestMakingFail"
        case .receivedInvalidData:
            return "receivedInvalidData"
        case .receivedIinvalidResponse:
            return "receivedIinvalidResponse"
        case .receivedFailureStatusCode(let code):
            return "FailureStatusCode : \(code)"
        case .HTTPBodyMakingFail:
            return "HTTPBodyMakingFail"
            
        //JSON Parsing Error
        case .encodingFail(let from, let to):
            return "encodingFail (from: \(from) -> to: \(to))"
        case .decodingFail(let from, let to):
            return "decodingFail (from: \(from) -> to: \(to))"
        }
    }
}
