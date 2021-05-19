//
//  MarketAPI.swift
//  OpenMarket
//
//  Created by Fezz, Tak on 2021/05/12.
//

import Foundation

enum MarketAPI {
    static let baseURL = "https://camp-open-market-2.herokuapp.com"
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    enum Path {
        case items
        case registrate
        case item
        case edit
        case delete
        
        var route: String {
            switch self {
            case .items:
                return "/items/"
            case .registrate:
                return "/item"
            case .item:
                return "/item/"
            case .edit:
                return "/item/"
            case .delete:
                return "/item/"
            }
        }
    }
}


