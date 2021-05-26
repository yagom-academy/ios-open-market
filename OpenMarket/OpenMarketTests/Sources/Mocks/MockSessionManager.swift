//
//  MockSessionManager.swift
//  OpenMarketTests
//
//  Created by duckbok on 2021/05/26.
//

import UIKit
@testable import OpenMarket

class MockSessionManager: SessionManagerProtocol {
    let items = NSDataAsset(name: "Page")!.data
    let item = NSDataAsset(name: "Item")!.data

    func request(method: HTTPMethod,
                 path: URLPath,
                 completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        switch method {
        case .get where path == .page(id: 1):
            completionHandler(.success(items))
        case .get where path == .item(id: 1):
            completionHandler(.success(item))
        default:
            completionHandler(.failure(.sessionError))
        }
    }
    
    func request<APIModel: RequestData>(method: HTTPMethod,
                                        path: URLPath,
                                        data: APIModel,
                                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void) {
        switch method {
        case .post where path == .item():
            completionHandler(.success(item))
        case .patch where path == .item(id: 1), .delete where path == .item(id: 1):
            completionHandler(.success(item))
        default:
            completionHandler(.failure(.sessionError))
        }
    }
}
