//
//  URLGenerator.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/24.
//

import Foundation

enum URLGenerator {
    static func generate(from method: HttpMethod) -> URL? {
        let path = targetPath(about: method)
        
        guard let url = URL(string: path) else {
            return nil
        }
        
        return url
    }
    
    private static func targetPath(about method: HttpMethod) -> String {
        var path = HttpConfig.baseURL
        
        switch method {
        case .getImage(let url):
            path = url
        case .getGoodsList(let pageIndex):
            path += "items/\(pageIndex.description)"
        case .getGoods(let id),
             .patchGoods(let id),
             .deleteGoods(let id):
            path += "item/" + id
        case .postGoods:
            path += "item"
        }
        
        return path
    }
}
