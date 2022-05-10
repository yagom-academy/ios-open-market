//
//  JsonDecoder.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

struct JsonParser {
    private let jsonDecoder =  JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    func decodingJson<T: Decodable>(json: Data) -> T? {
        return try? jsonDecoder.decode(T.self, from: json)
    }
    
    func encodingJson<T: Encodable>(target: T) -> Data? { // 추후 매개변수 이름 변경 예정
        return try? jsonEncoder.encode(target)
    }
}


