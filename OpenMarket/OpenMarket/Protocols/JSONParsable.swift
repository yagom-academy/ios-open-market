//
//  Parsable.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/05.
//

import Foundation

protocol JSONParsable {
    func parse<T: Decodable>(with data: Data, type: T.Type) -> T?
    func encode<T: Encodable>(with data: T) -> Data?
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
    
    func encode<T: Encodable>(with data: T) -> Data? {
        do {
            let encodedData = try JSONEncoder().encode(data)
            return encodedData
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
