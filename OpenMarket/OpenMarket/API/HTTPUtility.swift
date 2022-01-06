//
//  HTTPUtility.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/06.
//

import Foundation

enum HTTPUtility {
    static let baseURL: String = "https://market-training.yagom-academy.kr/"
    static let defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
}
