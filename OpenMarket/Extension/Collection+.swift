//
//  Collection+.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/22.
//

extension Collection {
    subscript(valid index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
