//
//  JsonUtil.swift
//  OpenMarketTests
//
//  Created by Luyan, Ellen on 2021/08/16.
//

import Foundation

enum JsonUtil {
    static func loadJsonData(_ name: String) -> Data? {
        if let path = Bundle.main.path(forResource: name, ofType: "json"),
           let jsonData = try? String(contentsOfFile: path).data(using: .utf8) {
            return jsonData
        }
        return nil
    }
}
