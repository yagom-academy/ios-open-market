//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/12.
//

import Foundation

struct URLSessionProvider {
    let session: URLSessionProtocol
    let baseURL = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
}
