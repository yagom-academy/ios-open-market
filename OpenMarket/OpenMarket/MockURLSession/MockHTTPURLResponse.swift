//
//  MockHTTPURLResponse.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 17/11/2022.
//

import Foundation

final class MockHTTPURLResponse: HTTPURLResponse {
    override var mimeType: String {
        return "application/json"
    }
}
