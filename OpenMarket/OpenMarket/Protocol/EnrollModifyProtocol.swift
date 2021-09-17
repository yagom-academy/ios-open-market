//
//  Networkable.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/15.
//

import Foundation

protocol Networkable {
    var placeholderList: [String] { get }
    var essentialPublicElement: EssentialPublicElement { get }
    var requestAPI: Requestable { get }
}
