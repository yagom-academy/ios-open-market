//
//  MockSession.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/15.
//

import UIKit.NSDataAsset
import Foundation

final class MockSession: SessionProtocol {
    func dataTask(with request: APIRequest,
                              completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let mockData = NSDataAsset(name: URLAdditionalPath.product.mockFileName)?.data
        else {
            completionHandler(.failure(CodableError.decode))
            return
        }
        
        completionHandler(.success(mockData))
    }
}
