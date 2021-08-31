//
//  RequestProtocol.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import Foundation

protocol Requestable {
    var url: String { get }
    var method: APIMethod { get }
    var contentType: ContentType { get }
    var parameter: [String: Any]? { get }
}
