//  Identifiable.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/20.

import Foundation

protocol Identifiable {
    associatedtype ID = Hashable
    
    var ID: Int { get }
}
