import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidRequest
    
    var desciption: String {
        switch self {
        case .invalidURL:
            return "URL이 유효하지 않습니다"
        case .invalidResponse:
            return "Response가 유효하지 않습니다"
        case .invalidData:
            return "Data가 유효하지 않습니다"
        case .invalidRequest:
            return "Request가 유효하지 않습니다"
        }
    }
}
