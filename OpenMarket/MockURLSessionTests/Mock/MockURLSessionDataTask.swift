//
//  OpenMarket - MockURLSessionDataTask.swift
//  Created by Zhilly, Dragon. 22/11/17
//  Copyright © yagom. All rights reserved.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}

    override func resume() {
        resumeDidCall()
    }
}
