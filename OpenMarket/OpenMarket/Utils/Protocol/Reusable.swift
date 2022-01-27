//
//  Reusable.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/27.
//

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
