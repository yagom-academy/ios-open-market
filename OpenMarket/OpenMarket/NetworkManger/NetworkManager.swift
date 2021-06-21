//
//  NetWorkManger.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//

import Foundation

class NetworkManager {
    static let baseURL: String = "https://camp-open-market-2.herokuapp.com/"
    let path: String = "items/"
    var page: String = "1"
    var url: URL { URL(string: NetworkManager.baseURL + path + page)! }
}
