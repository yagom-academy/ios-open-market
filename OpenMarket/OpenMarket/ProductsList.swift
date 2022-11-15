//
//  ProductsList.swift
//  OpenMarket
//
//  Created by Jpush, Aaron on 2022/11/14.
//

import Foundation

protocol completionable {}

typealias StatusCode = Int

extension StatusCode: completionable {}

struct ProductsList: Codable, completionable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Product]
}
