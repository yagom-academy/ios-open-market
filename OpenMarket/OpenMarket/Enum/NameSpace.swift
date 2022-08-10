//
//  NameSpace.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/10.
//

enum PriceText {
    case soldOut
    case stock
    
    var listText: String {
        switch self {
        case .soldOut:
            return "품절"
        case .stock:
            return "잔여수량 : "
        }
    }
    
    var detailText: String {
        switch self {
        case .soldOut:
            return "품절"
        case .stock:
            return "남은 수량 : "
        }
    }
}
