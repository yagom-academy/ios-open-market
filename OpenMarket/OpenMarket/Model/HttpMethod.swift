//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/19.
//

import Foundation

enum HttpMethod: String, CustomStringConvertible, CaseIterable {
    case get    = "GET"
    case post   = "POST"
    case patch  = "PATCH"
    case delete = "DELETE"
    
    var description: String {
        switch self {
        case .get : return "GET"
        case .post : return "POST"
        case .patch : return "PATCH"
        case .delete : return "DELETE"
        }
    }
}
