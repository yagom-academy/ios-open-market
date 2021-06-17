//
//  APIProvider.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/17.
//

import Foundation

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var sampleData: Data { get }
    var headers: [String: String]? { get }
}
