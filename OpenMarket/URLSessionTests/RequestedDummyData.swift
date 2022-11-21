//
//  RequestedDummyData.swift
//  URLSessionTests
//
//  Created by Ayaan, junho on 2022/11/16.
//

import Foundation

struct RequestedDummyData {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completion: DataTaskCompletion? = nil
    
    func complete() {
        completion?(data, response, error)
    }
}
