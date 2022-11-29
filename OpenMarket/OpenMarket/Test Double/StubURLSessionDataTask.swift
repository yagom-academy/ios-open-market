//
//  StubURLSessionDataTask.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/16.
//

import Foundation

final class StubURLSessionDataTask: URLSessionDataTask {
    private var dummyData: DummyData?
    
    init(dummyData: DummyData?, completionHandler: DataTaskCompletionHandler?) {
        self.dummyData = dummyData
        self.dummyData?.completionHandler = completionHandler
    }
    
    override func resume() {
        self.dummyData?.completion()
    }
}
