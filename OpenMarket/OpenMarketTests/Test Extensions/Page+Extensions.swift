//
//  Page+Extensions.swift
//  OpenMarketTests
//
//  Created by Jun Bang on 2022/01/07.
//

import Foundation
@testable import OpenMarket

extension Page: Equatable {
    public static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.pageNumber == rhs.pageNumber &&
            lhs.itemsPerPage == rhs.itemsPerPage &&
            lhs.totalCount == rhs.totalCount &&
            lhs.offset == rhs.offset &&
            lhs.limit == rhs.limit &&
            lhs.products == rhs.products &&
            lhs.lastPage == rhs.lastPage &&
            lhs.hasNext == rhs.hasNext &&
            lhs.hasPrevious == rhs.hasPrevious
    }
}
