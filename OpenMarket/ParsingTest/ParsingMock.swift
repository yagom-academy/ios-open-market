//
//  ParsingMock.swift
//  ParsingTest
//
//  Created by 수박, ehd on 2021/08/10.
//

import UIKit

enum DecodingError: Error {
    case unknown
    case decodingFailed
}


protocol ParsingMock {
    associatedtype Model: Decodable
}

extension ParsingMock {
    
    func parse(about fileName: String) throws -> Model {
        guard let convertedAsset = NSDataAsset(name: fileName) else {
            throw DecodingError.unknown
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Model.self, from: convertedAsset.data)
        } catch {
            throw DecodingError.decodingFailed
        }
    }
}
