//
//  Parserable.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/05.
//

import Foundation

protocol JSONParserable {
    func decode<T: Decodable>(source: Data, decodingType: T.Type) -> Result<T, ParserError>
    func encode<T: Encodable>(object: T) -> Result<Data, ParserError>
}
