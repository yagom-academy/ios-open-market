//
//  Parsable.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/05.
//

import Foundation

protocol Parsable {
    func parse<T: Decodable>(with data: Data, type: T.Type) -> T
}

extension Parsable {
    func parse<T: Decodable>(with data: Data, type: T.Type) -> T {
        var parsedData = Data() as! T
        
        do {
            parsedData = try JSONDecoder().decode(type, from: data)
        } catch JSONError.parsingError {
            print(JSONError.parsingError.description)
        } catch {
            print(error.localizedDescription)
        }
        
        return parsedData
    }
}
