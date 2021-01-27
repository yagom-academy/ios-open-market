//
//  ItemDeletionRequest.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

struct ItemDeletionRequest: Codable {
    let id: UInt
    let password: String?
}
