//
//  StubURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by Jae-hoon Sim on 2022/01/03.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

class StubURLSessionDataTask: URLSessionDataTask {
    
    var dummyData: DummyData?
    var completionHandler: DataTaskCompletionHandler?
    
    init(dummy: DummyData?, completionHandler: DataTaskCompletionHandler?) {
        self.dummyData = dummy
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        completionHandler?(dummyData?.data, dummyData?.response, dummyData?.error)
    }
    
}
