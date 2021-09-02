//
//  NetworkDispatcher.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/03.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case serverError
    case clientError
    case dataNotFound
    case invalidURL
    
    var errorDescription: String {
        switch self {
        case .serverError:
            return "서버에서 에러가 발생했습니다."
        case .clientError:
            return "클라이언트 에러가 발생했습니다."
        case .dataNotFound:
            return "데이터를 찾지 못했습니다."
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        }
    }
}

struct NetworkDispatcher {
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func prepareForRequest(of request: Request, _ suffix: String) -> Result<URLRequest, Error> {
        guard let url = URL(string: Request.baseURL + request.path + suffix) else {
            return .failure(NetworkError.invalidURL)
        }
        let userRequest = URLRequest(url: url)
        return .success(userRequest)
    }
}
