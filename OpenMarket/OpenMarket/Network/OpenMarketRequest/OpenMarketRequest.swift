//
//  OpenMarketRequest.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/09.
//

import Foundation

protocol OpenMarketInfoOwner {
    
    var baseURL: String { get }
    
}

extension OpenMarketInfoOwner {
    
    var baseURL: String {
        return "https://market-training.yagom-academy.kr"
    }
    
}

protocol OpenMarketAPIRequest: APIRequest, OpenMarketInfoOwner { }
protocol OpenMarketJSONRequest: JSONRequest, OpenMarketInfoOwner { }
protocol OpenMarketMultiPartRequest: MultiPartRequest, OpenMarketInfoOwner { }
