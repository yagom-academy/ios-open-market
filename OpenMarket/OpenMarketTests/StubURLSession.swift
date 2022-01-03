//
//  StubURLSession.swift
//  OpenMarketTests
//
//  Created by JeongTaek Han on 2022/01/03.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
}

class StubURLSession: URLSessionProtocol {
    var dummyData: DummyData?
    init(dummy: DummyData) {
        self.dummyData = dummy
    }
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        return StubURLSessionDataTask(dummy: dummyData, completionHandler: completionHandler)
    }
}
