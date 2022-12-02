//
//  PositiveNumber.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/22.
//

@propertyWrapper
struct PositiveNumber<T: Numeric> where T: Comparable {
    private var number: T = 0
    var wrappedValue: T {
        get { return number }
        set { number = max(0, newValue) }
    }
}
