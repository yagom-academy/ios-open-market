//
//  APIType.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

protocol APIType {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var headers: [String: String] { get }
    var body: Data { get }
    
    func generateURL() -> URL?
    func generateRequest() -> URLRequest?
}
