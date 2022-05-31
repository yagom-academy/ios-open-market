//
//  InputError.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/25.
//

import Foundation

enum InputError: LocalizedError {
    case productNameIsTooShort
    case productPriceIsEmpty
    case discountedPriceHigherThanPrice
    case productImageIsEmpty
    case exceededNumberOfImages
    case descriptionIsTooLong

    var errorDescription: String? {
        switch self {
        case .productNameIsTooShort: return "상품명을 3글자 이상 입력해 주세요."
        case .productPriceIsEmpty: return "상품가격이 비어있거나 숫자가 아닙니다."
        case .discountedPriceHigherThanPrice: return "할인금액이 가격보다 더 클 수 없습니다."
        case .productImageIsEmpty: return "1개 이상의 사진이 필요합니다."
        case .exceededNumberOfImages: return "사진은 5장만 등록할 수 있습니다."
        case .descriptionIsTooLong: return "설명은 1000자 이하로 입력 가능합니다."
        }
    }
}
