//
//  DummyData.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation
@testable import OpenMarket

struct DummyData {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    var completionHandler: DataTaskCompletionHandler? = nil
    
    func resumeCompletion() {
        completionHandler?(data, response, error)
    }
}
