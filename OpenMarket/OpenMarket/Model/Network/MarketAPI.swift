//
//  MarketAPI.swift
//  OpenMarket
//
//  Created by Tak on 2021/06/01.
//

import Foundation

enum MarketAPI {
    private static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    case 목록조회(page: Int)
    case 상품등록
    case 상품조회(id: Int)
    case 상품수정(id: Int)
    case 상품삭제(id: Int)
    
    var url: URL? {
        switch self {
        case .목록조회(let page):
            return URL(string: MarketAPI.baseURL + "/items/" + "\(page)")
        case .상품등록:
            return URL(string: MarketAPI.baseURL + "/item")
        case .상품조회(let id):
            return URL(string: MarketAPI.baseURL + "/item/" + "\(id)")
        case .상품수정(let id):
            return URL(string: MarketAPI.baseURL + "/item/" + "\(id)")
        case .상품삭제(let id):
            return URL(string: MarketAPI.baseURL + "/item/" + "\(id)")
        }
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}
