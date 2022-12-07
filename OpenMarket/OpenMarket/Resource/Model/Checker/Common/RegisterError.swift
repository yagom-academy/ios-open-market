//
//  RegisterError.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

enum RegisterError: String, Error {
    case wrongImage = "이미지 에러"
    case wrongName = "상품명 에러"
    case wrongDescription = "설명 에러"
    case wrongPrice = "가격 에러"
    case wrongCurrency = "화폐 단위 에러"
    case wrongDiscount = "할인 가격 에러"
    
    
    var description: String {
        switch self {
        case .wrongImage:
            return "이미지 개수는 1개 이상 5개 이하입니다."
        case .wrongName:
            return "상품명의 길이는 3 ~ 100자 입니다."
        case .wrongDescription:
            return "설명은 10 ~ 1000자 입니다."
        case .wrongPrice:
            return "가격은 숫자만 입력할 수 있습니다."
        case .wrongCurrency:
            return "잘못된 입력입니다."
        case .wrongDiscount:
            return "할인 가격은 원래 가격보다 높을 수 없습니다."
        }
    }
}
