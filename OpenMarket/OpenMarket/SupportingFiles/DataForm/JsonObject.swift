//
//  JsonObject.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/20.
//

import Foundation

struct JsonObject: DataForm {
    private let data: [String: Any]
    var contentType: String = "application/json"
    
    init(data: [String: Any]) {
        self.data = data
    }
    
    func createBody() throws -> Data? {
        return try? JSONSerialization.data(withJSONObject: self.data, options: [])
    }
}
