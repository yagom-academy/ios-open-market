//
//  StubURLSessionDataTask.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/16.
//

import Foundation

class StubURLSessionDataTask: URLSessionDataTask {
    var dummyData: DummyData?
    
    init(dummyData: DummyData?, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.dummyData = dummyData
        self.dummyData?.completionHandler = completionHandler
    }
    
    override func resume() {
        self.dummyData?.completion()
    }
}
