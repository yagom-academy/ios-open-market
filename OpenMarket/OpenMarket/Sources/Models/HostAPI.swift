//
//  HostAPI.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/19.
//

enum HostAPI {
    case openMarket
    
    var url: String {
        switch self {
        case .openMarket:
            return "https://market-training.yagom-academy.kr"
        }
    }
}
