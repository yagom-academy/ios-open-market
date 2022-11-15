//
//  DummyData.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation
@testable import OpenMarket

struct DummyData {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: DataTaskCompletionHandler? = nil
    
    func resumeCompletion() {
        completionHandler?(data, response, error)
    }
}
