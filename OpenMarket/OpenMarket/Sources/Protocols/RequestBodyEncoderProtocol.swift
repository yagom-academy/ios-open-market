//
//  RequestBodyEncoderProtocol.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

protocol RequestBodyEncoderProtocol {
    func encode(_ value: RequestData) throws -> Data
}
