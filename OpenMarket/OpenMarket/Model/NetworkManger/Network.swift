//
//  NetWorkManger.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//

import Foundation

enum Network {
    case firstPage
    
    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    var path: String { "items/:9" } // 무관함을 위해 9페이지
    var url: URL { URL(string: Network.baseURL + path)! }
}
