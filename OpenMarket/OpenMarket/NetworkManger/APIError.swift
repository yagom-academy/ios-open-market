//
//  APIError.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//

import Foundation

enum APIError: String, Error, CustomStringConvertible {
    case unknown = "unkownError"
    case tableViewCell = "tableViewCellError"
    case collectionViewCell = "collectionViewCellError"
    case image = "imageError"
    case http = "httpError"
    
    var description: String {
        return "\(self.rawValue)"
    }
}
