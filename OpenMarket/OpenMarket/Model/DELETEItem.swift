//
//  DELETEItem.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

struct DELETEItem: Encodable {
    private let password: String

    init(password: String) {
        self.password = password
    }
}
