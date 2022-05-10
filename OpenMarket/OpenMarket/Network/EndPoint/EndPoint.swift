//
//  EndPoint.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/10.
//

import Foundation

final class EndPoint: Requestable {
    var baseURL: String
    var path: String
    var method: HttpMethod
    var queryParameters: Encodable?
    var bodyParameters: Encodable?
    var headers: [String: String]?
    var sampleData: Data?

    init(baseURL: String = "https://market-training.yagom-academy.kr/",
         path: String = "",
         method: HttpMethod = .get,
         queryParameters: Encodable? = nil,
         bodyParameters: Encodable? = nil,
         headers: [String: String]? = [:],
         sampleData: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
        self.sampleData = sampleData
    }
}
