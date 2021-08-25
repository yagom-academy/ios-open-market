//
//  URLGenerator.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/24.
//

import Foundation

struct URLGenerator {
    private static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    
    static func generate(from method: HttpMethod) -> URL? {
        let path = targetPath(about: method)
        
        guard let url = URL(string: path) else {
            return nil
        }
        
        return url
    }
    
    private static func targetPath(about method: HttpMethod) -> String {
        var path = baseURL
        
        switch method {
        case .items(let pageIndex):
            path += "items/\(pageIndex.description)"
        case .item(let id),
             .patch(let id),
             .delete(let id):
            path += "item/" + id
        case .post:
            path += "item"
        }
        
        return path
    }
}
