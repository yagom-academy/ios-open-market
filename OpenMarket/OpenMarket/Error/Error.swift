//
//  Error.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/16.
//

import Foundation

enum OpenMarketError: Error, LocalizedError {
    case badStatus(file: StaticString = #file, line: UInt = #line)
    case invalidURL(file: StaticString = #file, line: UInt = #line)
    
    var errorDescription: String? {
        switch self {
        case .badStatus(let file, let line):
            return "file: \(file), line: \(line): Responsed Bad Status Code"
        case .invalidURL(let file, let line):
            return "file: \(file), line: \(line): Invalid URL"
        }
    }
}
