//
//  HttpBodyConvertible.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

protocol HttpBodyConvertible {
    var contentType: ContentType { get }
    var data: Data { get }
    func convertHttpBody() -> HttpBody
}

extension HttpBodyConvertible {
    func convertHttpBody() -> HttpBody {
        return .init(contentType: contentType, data: data)
    }
}
