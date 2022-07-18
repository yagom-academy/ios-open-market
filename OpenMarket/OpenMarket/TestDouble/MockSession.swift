//
//  MockSession.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/15.
//

import UIKit.NSDataAsset

final class MockSession: SessionProtocol {
    func dataTask<T: Codable>(with request: APIRequest,
                              completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let mockData = NSDataAsset(name: request.path.mockFileName)?.data else {
            completionHandler(.failure(CodableError.decode))
            return
        }
        guard let model = try? JSONDecoder().decode(T.self, from: mockData) else {
            completionHandler(.failure(CodableError.decode))
            return
        }
        completionHandler(.success(model))
    }
}
