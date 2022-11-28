//
//  ReuseIdentifierProtocol+Extension.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/21.
//

protocol ReuseIdentifierProtocol {
    
}

extension ReuseIdentifierProtocol {
    static var reuseIdentifier: String {
        return String.init(describing: self)
    }
}
