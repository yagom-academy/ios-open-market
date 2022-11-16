//
//  StubURLSession.swift
//  URLSessionTests
//
//  Created by Ayaan on 2022/11/16.
//

import Foundation

final class StubURLSession {
    var dummyData: RequestedDummyData?
    
    init(dummy: RequestedDummyData) {
        self.dummyData = dummy
    }
    
    func dataTask(completion: @escaping DataTaskCompletion) -> URLSessionDataTask {
        return StubURLSessionDataTask(dummy: dummyData, completion: completion)
    }
}
