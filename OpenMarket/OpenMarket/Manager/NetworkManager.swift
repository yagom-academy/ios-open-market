//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/01.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case responseFailed
    case invalidHttpMethod
    case requestFailed
    case dataTaskError
    case dataNotfound
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .responseFailed:
            return "200에서 299 상태코드를 받는데 실패했습니다."
        case .invalidHttpMethod:
            return "잘못된 HTTPMethod입니다."
        case .requestFailed:
            return "리퀘스트를 받는데 실패했습니다."
        case .dataTaskError:
            return "dataTask 전달 중 에러가 발생했습니다."
        case .dataNotfound:
            return "data를 전달 받지 못했습니다."
        }
    }
}

class NetworkManager {
    private let request = Request()
    private let session: URLSessionProtocol
    private var valuableMethod: [APIMethod] = []
    private static let rangeOfSuccessState = 200...299
    
    init(session: URLSessionProtocol = URLSession.shared,
         valuableMethod: [APIMethod] = APIMethod.allCases) {
        self.session = session
        self.valuableMethod = valuableMethod
    }
    
    func commuteWithAPI(API: Requestable, completionHandler: @escaping(Result<Data, Error>) -> Void) {
        guard let request = try? request.createRequest(url: API.url, API: API) else {
            completionHandler(.failure(NetworkError.requestFailed))
            return
        }
        guard valuableMethod.contains(API.method) else {
            completionHandler(.failure(NetworkError.invalidHttpMethod))
            return
        }
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(NetworkError.dataTaskError))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (Self.rangeOfSuccessState).contains(response.statusCode) else {
                completionHandler(.failure(NetworkError.responseFailed))
                return
            }
            debugPrint(response)
            
            guard let data = data else {
                completionHandler(.failure(NetworkError.dataNotfound))
                return
            }
            debugPrint(String(decoding: data, as: UTF8.self))
            completionHandler(.success(data))
        }.resume()
    }
}
