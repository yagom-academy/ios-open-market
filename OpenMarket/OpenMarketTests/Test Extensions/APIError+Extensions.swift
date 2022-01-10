//
//  APIError+Extensions.swift
//  OpenMarketTests
//
//  Created by 권나영 on 2022/01/10.
//

import Foundation
@testable import OpenMarket

extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.description == rhs.description
    }
}
