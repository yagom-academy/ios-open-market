//
//  StubURLSession.swift
//  OpenMarket
//
//  Created by papri, Tiana on 11/05/2022.
//

import Foundation

struct DummyData {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil
    
    func completion() {
        completionHandler?(data, response, error)
    }
}
