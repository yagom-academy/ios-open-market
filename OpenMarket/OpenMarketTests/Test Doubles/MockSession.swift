//
//  MockNetwork.swift
//  OpenMarketTests
//
//  Created by Ari on 2022/01/05.
//

import Foundation
@testable import OpenMarket

class MockSession {
    static var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
