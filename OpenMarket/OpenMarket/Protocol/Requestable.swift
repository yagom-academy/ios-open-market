//
//  Requestable.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/19.
//

import UIKit

protocol Requestable {
    var format: ApiFormat { get }
    var contentType: ContentType { get }
    var parameter: [String: Any]? { get }
    var items: [UIImage]? { get }
}

