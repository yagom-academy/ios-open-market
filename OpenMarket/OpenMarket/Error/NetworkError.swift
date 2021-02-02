import Foundation

enum NetworkError: Error {
    case request
    case response
    case data
    case url
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .request:
            return "잘못된 요청입니다."
        case .response:
            return "네트워크 오류가 있습니다."
        case .data:
            return "데이터가 오지 않았습니다."
        case .url:
            return "url 변환에 실패했습니다."
        }
    }
}
