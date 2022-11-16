//
//  StubURLSession.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/16.
//

import Foundation

class StubURLSession: URLSessionProtocol {
    var dummyData: DummyData?
    
    init(dummyData: DummyData) {
        self.dummyData = dummyData
    }
        
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        return StubURLSessionDataTask(dummyData: dummyData, completionHandler: completionHandler)
    }
}
