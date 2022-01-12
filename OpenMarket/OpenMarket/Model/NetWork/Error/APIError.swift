import Foundation

enum APIError: LocalizedError {
    case invalidData
    case invalidResponse
    case notProperStatusCode
    case decodingFail
    case encodingFail
    case URLConversionFail
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "데이터 형식이 잘못되었습니다."
        case .invalidResponse:
            return "Response 형식이 잘못되었습니다."
        case .notProperStatusCode:
            return "통신에 실패했습니다."
        case .decodingFail:
            return "디코딩에 실패했습니다."
        case .encodingFail:
            return "인코딩에 실패했습니다."
        case .URLConversionFail:
            return "URL 변환에 실패했습니다."
        }
    }
}
