//
//  Path.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/15.
//

import Foundation

struct Path {
    static let item = "/item"
    
    struct Item {
        static let page = Path.item + "/:page"
        static let id = Path.item + "/:id"
    }
}

