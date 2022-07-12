//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/12.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    
    let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask {
            completion(self.response.data, self.response.urlResponse, self.response.error)
        }
    }
}
