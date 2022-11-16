//
//  StubURLSessionDataTask.swift
//  URLSessionTests
//
//  Created by Ayaan, junho on 2022/11/16.
//

import Foundation

final class StubURLSessionDataTask: URLSessionDataTask {
    var dummyData: RequestedDummyData?
    
    init(dummy: RequestedDummyData?, completion: DataTaskCompletion?) {
        self.dummyData = dummy
        self.dummyData?.completion = completion
    }
    
    override func resume() {
        dummyData?.complete()
    }
}
