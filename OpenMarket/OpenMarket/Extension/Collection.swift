//
//  Collection.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/28.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}
