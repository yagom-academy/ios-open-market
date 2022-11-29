//
//  Market.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 15/11/2022.
//

import Foundation

struct Market: Decodable, Hashable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Page]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
}
