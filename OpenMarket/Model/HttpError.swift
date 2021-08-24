//
//  httpError.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/16.
//

import Foundation

struct HttpError: ErrorMessage {
    static let unknownError = "Error: unknown error occured"
    
    var errorDescription: String?
    
    init(message: String) {
        self.errorDescription = message
    }
}
