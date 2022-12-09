//
//  CollectionViewLayout.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/23.
//

enum CollectionViewLayout {
    case list
    case grid
    case imagePicker
    
    static var defaultLayout: CollectionViewLayout {
        return .list
    }
}
