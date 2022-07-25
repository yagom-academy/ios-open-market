//
//  MockURLSessionProtocol.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with request: APIRequest,
                              completionHandler: @escaping (Result<Data, Error>) -> Void)
}
