//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by 박병호 on 2022/01/07.
//

import Foundation

class MockSession {
    static var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
