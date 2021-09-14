//
//  singleton.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/14.
//

import Foundation

class CollectionViewProperty {
    static var shared = CollectionViewProperty()
    var isListView: Bool = true
    private init() {}
}
