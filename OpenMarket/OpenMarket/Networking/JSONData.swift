//
//  JSONData.swift
//  OpenMarket
//
//  Created by 케이, 수꿍 on 2022/07/11.
//

import Foundation

struct JSONData {
    static func parse(fileName: String, fileExtension: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            return nil
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            return nil
        }
        let data = jsonString.data(using: .utf8)
        return data
    }
    
    static func decode<T: Decodable>(fileName: String, fileExtension: String, dataType: T.Type) -> T? {
        guard let parsedData = JSONData.parse(fileName: fileName, fileExtension: fileExtension) else {
            return nil
        }
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(T.self, from: parsedData)
        return decodedData
    }
}
