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
    
    func send(request: Request, _ suffix: Int, completion: @escaping (Result<Data, Error>) -> ()) {
        let preparedResult = prepareForRequest(of: request, suffix)
        switch preparedResult {
        case .success(let userRequest):
            let task = session.dataTask(with: userRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(NetworkError.serverError))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode) else {
                    completion(.failure(NetworkError.clientError))
                    return
                }
                guard let data = data else {
                    completion(.failure(NetworkError.dataNotFound))
                    return
                }
                completion(.success(data))
            }
            task.resume()
        case .failure(let error):
            completion(.failure(error))
            return
        }
        return
    }
    
    func prepareForRequest(of request: Request, _ suffix: Int) -> Result<URLRequest, Error> {
        guard let url = URL(string: Request.baseURL + request.path + " \(suffix)") else {
            return .failure(NetworkError.invalidURL)
        }
        let userRequest = URLRequest(url: url)
        return .success(userRequest)
    }
}
