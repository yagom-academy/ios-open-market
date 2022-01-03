//
//  StubURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by Jae-hoon Sim on 2022/01/03.
//

import Foundation

class StubURLSessionDataTask: URLSessionDataTask {
    var dummyData: DummyData?
    
    init(dummy: DummyData?, completionHandler: DataTaskCompletionHandler?) {
        self.dummyData = dummy
        self.dummyData?.completionHandler = completionHandler
    }
    
    override func resume() {
        dummyData?.completion()
    }
}
