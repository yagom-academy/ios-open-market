//
//  Mock.swift
//  OpenMarketTests
//
//  Created by 윤재웅 on 2021/05/21.
//

import Foundation

import Foundation
@testable import OpenMarket

class MockNetworkloader: MarketNetwork {
    var inputRequest: URLRequest?
    var executeCalled = false
    var resultToreturn: Result<Data, Error>?
    
    func excuteNetwork(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        executeCalled = true
        inputRequest = request
        completion(resultToreturn!)
    
    }
}

class MockDecoder: Decoderable {
    func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
        if type == MarketItems.self {
            return MarketItems(page: 1,
                               items: []) as! T
        } else if  type == MarketItem.self {
            return MarketItem(id: 1,
                              title: "",
                              descriptions: "",
                              price: 1,
                              currency: "",
                              stock: 1,
                              discountedPrice: 1,
                              thumbnails: [],
                              images: [],
                              registrationData: 0.0) as! T
        } else {
            throw(MarketError.decoding)
        }
    }
}

