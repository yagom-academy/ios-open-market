//
//  URLManager.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/25.
//

import Foundation

struct URLManager {
    enum Path: String {
        case itemsList = "items/"
        case item = "item/"
    }
    
    let baseURL = "https://camp-open-market.herokuapp.com/"
    
    func makeURL(path: Path, value: Int) -> URL? {
        var url = URLComponents(string: baseURL)
        url?.path = path.rawValue + String(value)
        
        return url?.url
    }
}
