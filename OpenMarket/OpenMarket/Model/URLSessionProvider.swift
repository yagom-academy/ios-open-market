//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/04.
//

import Foundation
import Metal

class URLSessionProvider {
    let session: URLSession
    var baseURL: String = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
}
