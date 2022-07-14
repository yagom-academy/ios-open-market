//
//  MockSession.swift
//  OpenMarket
//
//  Created by NAMU on 2022/07/14.
//

import Foundation
import UIKit.NSDataAsset

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeDidCall: () -> Void = { }
    
    func resume() {
        resumeDidCall()
    }
}

protocol MockAPIRequest { }

extension MockAPIRequest {
    func requestMockData<T: Codable>(url: String,
                                     with urlQueryItems: [URLQueryItem],
                                     completion: @escaping (Result<T, Error>) -> Void)
    {
        var urlComponets = URLComponents(string: url)
        urlQueryItems.forEach { urlComponets?.queryItems?.append($0) }
        guard let url = urlComponets?.url else { return }
        
        let data = NSDataAsset(name: "MockData")?.data
        let response = HTTPURLResponse(url: url, statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        let urlRequest = URLRequest(url: url)
        
        let task = stubUrlSession.mockDataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error ?? NetworkError.request))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 <= response.statusCode, response.statusCode < 300
            else {
                completion(.failure(NetworkError.response))
                return
            }
            
            guard let safeData = data else { return }
            guard let decodedData = try? JSONDecoder().decode(T.self,
                                                              from: safeData)
            else {
                completion(.failure(CodableError.decode))
                return
            }
            completion(.success(decodedData))
        }
        task.resume()
    }
}
