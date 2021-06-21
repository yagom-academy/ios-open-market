//
//  NetWorkManger.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//

import Foundation

enum Network {    
    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    var path: String { "items/:1" }
    var url: URL { URL(string: Network.baseURL + path)! }
}
