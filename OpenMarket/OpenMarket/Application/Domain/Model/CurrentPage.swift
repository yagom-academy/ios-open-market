//
//  CurrentPage.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

enum CurrentPage: String {
    case productEnrollment
    case productModification
    
    var title: String {
        switch self {
        case .productEnrollment:
            return "상품등록"
        case .productModification:
            return "상품수정"
        }
    }
}
