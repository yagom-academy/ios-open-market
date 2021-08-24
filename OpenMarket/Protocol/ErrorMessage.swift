//
//  ErrorMessage.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/19.
//

import Foundation

protocol ErrorMessage: LocalizedError, Codable {
    init(message: String)
}
