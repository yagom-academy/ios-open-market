//
//  ErrorMessage.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/19.
//

import Foundation

protocol Messagable {
    init(message: String)
}

typealias ErrorMessage = Error & Messagable & Codable
