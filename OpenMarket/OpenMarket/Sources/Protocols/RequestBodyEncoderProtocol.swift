//
//  RequestBodyEncoderProtocol.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

protocol RequestBodyEncoderProtocol {
    var boundary: String { get }
    func encode<T: RequestData>(_ value: T) throws -> Data
}
