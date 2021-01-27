//
//  FeatureList.swift
//  OpenMarket
//
//  Created by 김태형 on 2021/01/27.
//

import Foundation

enum FeatureList {
    case listSearch
    case productRegistration
    case productSearch
    case productModification
    case deleteProduct
    
    var urlPath: String {
        switch self {
        case .listSearch:
            return "/items/"
        case .productRegistration:
            return "/item/"
        case .productSearch:
            return "/item/"
        case .productModification:
            return "/item/"
        case .deleteProduct:
            return "/item/"
        }
    }
}

