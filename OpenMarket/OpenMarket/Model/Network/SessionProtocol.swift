//
//  MockURLSessionProtocol.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

protocol SessionProtocol {
    func dataTask<T: Codable>(with request: APIRequest,
                              completionHandler: @escaping (Result<T, Error>) -> Void)
}
