//
//  CollectionViewLayout.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/23.
//

enum CollectionViewLayout {
    case list
    case grid
    
    static var defaultLayout: CollectionViewLayout {
        return .list
    }
}
