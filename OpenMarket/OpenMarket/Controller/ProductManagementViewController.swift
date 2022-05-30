//
//  Asd.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/30.
//

import UIKit

enum ProductManagementType: String {
    case Registration = "상품 등록"
    case correction = "상품 수정"
    
    var type: String {
        return self.rawValue
    }
}
