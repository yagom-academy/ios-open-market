//
//  APIType.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

protocol APIType {
    var baseURL: String { get }
    var path: String { get }
    var params: [String: String] { get }
    
    func generateURL() -> URL?
}
