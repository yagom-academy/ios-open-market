//
//  URLManager.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/25.
//

import Foundation

struct URLManager {
    enum Path {
        case itemsListPage(Int)
        case registItem
        case itemId(Int)
    }
    
    static let baseURL = "https://camp-open-market.herokuapp.com"
    
    static func makeURL(type: Path) throws -> URL {
        var urlStr = ""
        
        switch type {
        case .itemsListPage(let page):
            urlStr = "\(baseURL)/items/\(page)"
        case .registItem:
            urlStr = "\(baseURL)/item"
        case .itemId(let id):
            urlStr = "\(baseURL)/item/\(id)"
        }
        
        guard let url = URL(string: urlStr) else {
            throw NetworkingError.invalidURL
        }
        
        return url
    }
}


