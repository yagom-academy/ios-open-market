//
//  httpError.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/16.
//

import Foundation

struct HttpError: Error, Decodable {
    let message: String
}
