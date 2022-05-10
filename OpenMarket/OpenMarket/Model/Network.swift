//
//  Network.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

enum API {
    static let hostApi = "https://market-training.yagom-academy.kr"
    static func request() -> Network {
        Network(path: "/healthChecker")
    }
}
