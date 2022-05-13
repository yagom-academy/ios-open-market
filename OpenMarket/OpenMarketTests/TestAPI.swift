//
//  TestAPI.swift
//  OpenMarketTests
//
//  Created by Eddy, marisol on 2022/05/13.
//

import Foundation
@testable import OpenMarket

struct FakeAPI: APIable {
    var hostAPI: String = "fakeURL"
    var path: String = "/good"
    var param: [String : String]? = nil
    var method: HTTPMethod = .get
}

struct HealthChecker: APIable {
    var hostAPI: String = "https://market-training.yagom-academy.kr"
    var method: HTTPMethod = .get
    var param: [String : String]? = nil
    var path: String = "/healthChecker"
}
