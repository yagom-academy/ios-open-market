//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by Tak on 2021/06/03.
//

import Foundation

enum HTTPMethod: String {
    case 목록조회, 상품조회 = "GET"
    case 상품등록 = "POST"
    case 상품수정 = "PATCH"
    case 상품삭제 = "DELETE"
}
