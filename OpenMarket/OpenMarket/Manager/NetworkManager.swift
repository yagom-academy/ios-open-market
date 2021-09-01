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
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .responseFailed:
            return "200에서 299 상태코드를 받지 못했습니다."
        }
    }
}

class NetworkManager {
    private let request = Request()
    private static let rangeOfSuccessState = 200...299
    
    func commuteWithAPI(API: Requestable, completion: @escaping(Result<Data, Error>) -> Void) {
        guard let request = try? request.createRequest(url: API.url, API: API) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { return completion(.failure(error)) }
            
            guard let response = response as? HTTPURLResponse,
                  (Self.rangeOfSuccessState).contains(response.statusCode) else {
                return completion(.failure(NetworkError.responseFailed))
            }
            debugPrint(response)
            
            if let data = data {
                debugPrint(String(decoding: data, as: UTF8.self))
                completion(.success(data))
            }
        }.resume()
    }
}
