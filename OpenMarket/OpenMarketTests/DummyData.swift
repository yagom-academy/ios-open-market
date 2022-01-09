//
//  DummyData.swift
//  OpenMarketTests
//
//  Created by JeongTaek Han on 2022/01/03.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

struct DummyData {
    
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: DataTaskCompletionHandler?
    
    func completion() {
        completionHandler?(data, response, error)
    }
    
}
