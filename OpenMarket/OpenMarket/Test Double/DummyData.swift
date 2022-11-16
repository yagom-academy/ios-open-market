//
//  DummyData.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/16.
//

import Foundation

struct DummyData {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: DataTaskCompletionHandler?
    
    func completion() {
        completionHandler?(data, response, error)
    }
}
