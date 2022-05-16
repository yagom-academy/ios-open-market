//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by dudu, safari on 2022/05/09.
//

import Foundation

@testable import OpenMarket

struct DummyData {
    var data: Data?
    
    init() {
        guard let path = Bundle.main.path(forResource: "products", ofType: "json") else { return }
        guard let jsonString = try? String(contentsOfFile: path) else { return }
        data = jsonString.data(using: .utf8)
    }
}


