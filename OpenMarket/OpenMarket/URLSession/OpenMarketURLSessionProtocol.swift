//
//  OpenMarketURLSessionProtocol.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/16.
//

import Foundation

protocol OpenMarketURLSessionProtocol {
    var host: String { get }
    
    func fetchOpenMarketDataTask(query: String,
                                 completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask?
}

extension OpenMarketURLSessionProtocol {
    var host: String {
        return "https://openmarket.yagom-academy.kr"
    }
}
