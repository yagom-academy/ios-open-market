//
//  Decoderable.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/22.
//

import Foundation

protocol Decoderable {
    func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable
}
