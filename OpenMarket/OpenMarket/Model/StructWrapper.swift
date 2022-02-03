//
//  StructWrapper.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/02/03.
//

import Foundation

class StructWrapper<T>: NSObject {
    let value: T
    
    init(_ structValue: T) {
        value = structValue
    }
}
