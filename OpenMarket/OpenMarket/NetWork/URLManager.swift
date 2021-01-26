//
//  URL.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

enum NetworkMethod {
    case getList
    case getItem
    case postItem
    case patchItem
    case deleteItem
    
    var path: String {
        switch self {
        case .getList:
            return "/items"
        case .getItem, .postItem, .patchItem, .deleteItem:
            return "/item"
        }
    }
}

struct URLManager {
    private static let baseURL = "https://camp-open-market.herokuapp.com"
    
    static func makeURL(type: NetworkMethod, value: Int?) -> URL? {
        guard let urlString = makeUrlString(type: type, value: value) else {
            print("url 없음")
            return nil
        }
        let url = URL(string: urlString)
        return url
    }
    
    private static func makeUrlString(type: NetworkMethod, value: Int?) -> String? {
        var urlString = URLManager.baseURL
        urlString.append(type.path)
        switch type {
        case .getList:
            guard let page = value else {
                print("페이지를 입력하세요?")
                return nil
            }
            urlString.append("/\(page)")
            return urlString
        case .getItem:
            guard value == nil else {
                print("??")
                return nil
            }
            return urlString
        case .postItem, .patchItem, .deleteItem:
            guard let id = value else {
                print("id를 입력하세요")
                return nil
            }
            urlString.append("/\(id)")
            return urlString
        }
    }
}
