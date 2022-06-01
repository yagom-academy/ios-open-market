//
//  asdf.swift
//  OpenMarket
//
//  Created by song on 2022/05/30.
//

enum ManagementType: String {
    case registration = "상품 등록"
    case edit = "상품 수정"
    
    var type: String {
        return self.rawValue
    }
}
