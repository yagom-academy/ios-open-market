//
//  OpenMarket - Array+Extension.swift
//  Created by Zhilly, Dragon. 22/11/29
//  Copyright © yagom. All rights reserved.
//

extension Array {
    public subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
