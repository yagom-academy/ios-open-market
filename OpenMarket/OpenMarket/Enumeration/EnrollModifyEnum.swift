//
//  EnrollModifyEnum.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/15.
//

import Foundation

enum PostAndPatchParameter: String, CaseIterable {
    case id = "id"
    case title = "상품명"
    case currency = "화폐단위"
    case price = "가격"
    case discountedPrice = "할인가격"
    case stock = "재고수량"
    case descriptions = "상세설명"
    case password = "비밀번호"
    
    static var values: [String] = PostAndPatchParameter.allCases.map { $0.rawValue }
}

enum EssentialPublicElement {
    case post
    case patch
    
    var values: [String] {
        switch self {
        case .post:
            return ["상품명", "가격", "화폐단위", "상세설명", "재고수량", "비밀번호"]
        case .patch:
            return ["id", "비밀번호"]
        }
    }
}
