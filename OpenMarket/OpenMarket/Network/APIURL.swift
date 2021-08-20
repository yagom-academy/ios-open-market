//
//  APIURL.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/19.
//

import Foundation

enum APIURL: CustomStringConvertible {
    case getItems
    case getItem
    case post
    case patch
    case delete

    private static let baseUrl = "https://camp-open-market-2.herokuapp.com/"

    var description: String {
        switch self {
        case .getItems:
            return  Self.baseUrl + "items/"
        case .post, .getItem, .patch, .delete:
            return Self.baseUrl + "item/"
        }
    }
}
