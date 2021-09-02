//
//  RequestProtocol.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import Foundation

protocol Requestable {
    var url: String { get }
    var httpMethod: APIHTTPMethod { get }
    var contentType: ContentType { get }
}

protocol RequestableWithMultipartForm: Requestable {
    var parameter: [String: Any] { get }
    var image: [Media]? { get }
}
