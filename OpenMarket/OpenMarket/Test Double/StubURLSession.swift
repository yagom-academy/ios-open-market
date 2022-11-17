//
//  StubURLSession.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/16.
//

import Foundation

class StubURLSession: URLSessionProtocol {
    var dummyData: DummyData?
        
    func dataTask(with request: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        return StubURLSessionDataTask(dummyData: dummyData, completionHandler: completionHandler)
    }
}
