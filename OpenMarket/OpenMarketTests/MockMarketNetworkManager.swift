//
//  MockMarketNetworkManager.swift
//  OpenMarketTests
//
//  Created by 윤재웅 on 2021/05/19.
//

import Foundation
@testable import OpenMarket

class MockMarketNetworkManager: MarketNetwork {
    var inputRequest: URLRequest?
    var executeCalled = false

    func excuteNetwork(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        executeCalled = true
        inputRequest = request
    }
}

