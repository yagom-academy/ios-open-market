//
//  URLManager.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/25.
//

import Foundation

struct URLManager {
    enum Path {
        case itemsList(Int)
        case registItem
        case itemInfo(Int)
    }
    
    static let baseURL = "https://camp-open-market.herokuapp.com"
    
    static func makeURL(type: Path) throws -> URL {
        var urlStr = ""
        
        switch type {
        case .itemsList(let page):
            urlStr = "\(baseURL)/items/\(page)"
        case .registItem:
            urlStr = "\(baseURL)/item"
        case .itemInfo(let id):
            urlStr = "\(baseURL)/item/\(id)"
        }
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidURL
        }
        
        return url
    }
}


