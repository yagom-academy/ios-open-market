//
//  Reusable.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/27.
//

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        String(describing: self)
    }
}
