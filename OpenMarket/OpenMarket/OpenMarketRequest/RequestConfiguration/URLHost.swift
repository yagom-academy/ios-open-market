//
//  URLHost.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/05.
//

enum URLHost {
    case openMarket
    
    var url: String {
        switch self {
        case .openMarket:
            return "https://market-training.yagom-academy.kr"
        }
    }
}

