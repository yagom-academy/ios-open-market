import Foundation

enum NetworkError: Error {
    case wrongRequest
    case serverResponse
    case receiveData
    case convertURL
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongRequest:
            return "잘못된 요청입니다."
        case .serverResponse:
            return "네트워크 오류가 있습니다."
        case .receiveData:
            return "데이터가 오지 않았습니다."
        case .convertURL:
            return "url 변환에 실패했습니다."
        }
    }
}
