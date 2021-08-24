//
//  httpError.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/16.
//

import Foundation

struct HttpError: ErrorMessage {
    var errorDescription: String?
    
    init(message: String) {
        self.errorDescription = message
    }
}
