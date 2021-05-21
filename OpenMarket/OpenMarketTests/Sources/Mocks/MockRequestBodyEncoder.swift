//
//  MockRequestBodyEncoder.swift
//  OpenMarketTests
//
//  Created by 천수현 on 2021/05/18.
//

import Foundation
@testable import OpenMarket

struct MockRequestBodyEncoder: RequestBodyEncoderProtocol {
    static var boundary: String = ""
    func encode<T>(_ value: T) throws -> Data where T : RequestData {
        return Data()
    }
}
