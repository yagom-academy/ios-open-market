//
//  NetworkError.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/12.
//

import Foundation

enum NetworkError: Error {
    case unknownError
    case statusCodeError
    case decodeError
    case urlError
    case clientError
    case dataError
    case imageError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "알수없는 에러입니다"
        case .statusCodeError:
            return "상태코드 에러입니다"
        case .decodeError:
            return "디코드 에러입니다"
        case .urlError:
            return "잘못된url입니다"
        case .clientError:
            return "클라이언트 에러입니다"
        case .dataError:
            return "데이터가 없습니다."
        case .imageError:
            return "이미지 에러입니다"

        }
    }
}
