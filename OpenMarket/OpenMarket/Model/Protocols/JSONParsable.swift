//
//  Parsable.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/05.
//

import Foundation

protocol JSONParsable {
    func parse<T: Decodable>(with data: Data, type: T.Type) -> T?
}

extension JSONParsable {
    func parse<T: Decodable>(with data: Data, type: T.Type) -> T? {
        do {
            let parsedData = try JSONDecoder().decode(type, from: data)
            return parsedData
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
