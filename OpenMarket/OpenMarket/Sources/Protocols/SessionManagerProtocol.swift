//
//  SessionManagerProtocol.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/25.
//

import Foundation

protocol SessionManagerProtocol {
    func request(method: HTTPMethod,
                 path: URLPath,
                 completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)

    func request<APIModel: RequestData>(method: HTTPMethod,
                                        path: URLPath,
                                        data: APIModel,
                                        completionHandler: @escaping (Result<Data, OpenMarketError>) -> Void)
}
