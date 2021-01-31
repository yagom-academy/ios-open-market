//
//  ItemDeletion.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct ItemDeletionRequest: Encodable {
    let id: Int
    let password: String
}
