//
//  Requestable.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/19.
//

import UIKit

protocol Requestable {
    var url: String { get }
    var method: APIMethod { get }
    var contentType: ContentType { get }
}

protocol RequestableWithoutBody: Requestable{}

protocol RequestableWithBody: Requestable {
    var parameter: [String: Any]? { get }
    var items: [Media]? { get }
}
