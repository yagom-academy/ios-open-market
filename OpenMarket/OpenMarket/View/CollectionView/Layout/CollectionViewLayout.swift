//
//  CollectionViewLayout.swift
//  OpenMarket
//
//  Created by junho lee on 2022/11/23.
//

enum CollectionViewLayout {
    case list
    case grid
    
    static var defaultLayout: CollectionViewLayout {
        return .list
    }
}
