//
//  Request.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/02.
//

import Foundation

protocol RequestAPI {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
}

enum HTTPMethod {
    case get
    case post
    case patch
    case delete
}
