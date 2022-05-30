//
//  asdf.swift
//  OpenMarket
//
//  Created by song on 2022/05/30.
//

enum ManagementType: String {
    case Registration = "상품 등록"
    case correction = "상품 수정"
    
    var type: String {
        return self.rawValue
    }
}
