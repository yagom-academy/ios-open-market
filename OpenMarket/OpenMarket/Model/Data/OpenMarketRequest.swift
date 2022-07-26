//
//  OpenMarketRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import Foundation

struct OpenMarketRequest: APIRequest {
    var body: [String : [Data]]?
    var boundary: String?
    var path: String?
    var method: HTTPMethod
    var baseURL: String
    var headers: [String : String]?
    var query: [String: String]?
}

