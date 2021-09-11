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

struct NetworkManager {
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }

    func send(request: Request, of path: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let userRequest = request.configure(request: request, path: path)
        switch userRequest {
        case .success(let userRequest):
            let task = session.dataTask(with: userRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode) else {
                    completion(.failure(.clientError))
                    return
                }
                if let data = data {
                    completion(.success(data))
                }
            }
            task.resume()
        case .failure(let error):
            completion(.failure(error))
            return
        }
        return
    }
}
