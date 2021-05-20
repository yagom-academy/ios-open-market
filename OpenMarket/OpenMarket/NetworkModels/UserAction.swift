//
//  UserAction.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/18.
//

import Foundation

enum UserAction {
    
    case viewArticleList
    case addArticle
    case viewArticle
    case updateArticle
    case deleteArticle
    
    func setHttpMethod() -> String {
        switch self {
        case .viewArticleList, .viewArticle:
            return "GET"
        case .addArticle:
            return "POST"
        case .updateArticle:
            return "PATCH"
        case .deleteArticle:
            return "DELETE"
        }
    }
    
}
