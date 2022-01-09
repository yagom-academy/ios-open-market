//
//  HealthCheckerRequest.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/07.
//

import Foundation

struct HealthCheckerRequest: APIRequest {
    var method: String
    var header: [String : String]?
    var path: String
    
    init() {
        self.method = "GET"
        self.header = nil
        self.path = "/healthChecker"
    }
}
