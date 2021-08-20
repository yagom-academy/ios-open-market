//
//  JsonObject.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/20.
//

import Foundation

enum DataFormError: Error {
    case convertError
    case notFoundBoundary
}

struct JsonObject: DataForm {
    private let data: [String: Any]
    var contentType: String = "application/json"
    
    init(data: [String: Any]) {
        self.data = data
    }
    
    func createBody() throws -> Data? {
        guard let json = try? JSONSerialization.data(withJSONObject: self.data, options: []) else { throw DataFormError.convertError }
        return json
    }
}
