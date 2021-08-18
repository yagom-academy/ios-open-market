//
//  ItemRequestable.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/18.
//

import Foundation

struct ItemRequestable: Loopable {
    private(set) var title: String? = nil
    private(set) var descriptions: String? = nil
    private(set) var price: Int? = nil
    private(set) var currency: String? = nil
    private(set) var stock: Int? = nil
    private(set) var discountedPrice: Int? = nil
    
    let password: String
}
