//
//  MockNetworkModule.swift
//  OpenMarketTests
//
//  Created by 김준건 on 2021/08/17.
//

import Foundation
import UIKit.NSDataAsset
@testable import OpenMarket

struct MockNetworkModule: DataTaskRequestable {
    let isSuccessTest: Bool
    
    init(isSuccessTest: Bool) {
        self.isSuccessTest = isSuccessTest
    }
    
    func runDataTask(using request: URLRequest, with completionHandler: @escaping (Result<Data, Error>) -> Void) {
        var data: Data?
        
        switch request.httpMethod {
        case OpenMarketAPIConstants.listGet.method:
            data = NSDataAsset(name: "Items")?.data
        default:
            data = NSDataAsset(name: "Item")?.data
        }
        
        guard isSuccessTest, let data = data else {
            completionHandler(.failure(NetworkError.unknown))
            return
        }
        completionHandler(.success(data))
    }
}
