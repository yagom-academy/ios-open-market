import Foundation

enum NetworkError: Error {
    case requestError
    case responseError
    case dataError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestError:
            return "잘못된 요청입니다."
        case .responseError:
            return "에러 코드 응답이 왔습니다."
        case .dataError:
            return "데이터가 오지 않았습니다."
        }
    }
}
