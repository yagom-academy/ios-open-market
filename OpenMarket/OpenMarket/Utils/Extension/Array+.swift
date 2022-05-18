//
//  Array+.swift
//  OpenMarket
//
//  Created by papri, Tiana on 18/05/2022.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        guard self.indices ~= index else { return nil }
        return self[index]
    }
}
