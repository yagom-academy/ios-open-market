//
//  UserInputError.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/12/8.
//

import Foundation

enum UserInputError: Error {
    case noImageInput
    case invalidNameInput
    case invalidPriceInput
    case invalidDiscountInput
    case invalidStockInput
    case invalidDescriptionInput
    case discountOverPrice
}

extension UserInputError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidNameInput:
            return NSLocalizedString("3자 이상, 100자 이하의 상품 이름을 입력해주세요.",
                                     comment: "invalid name input")
        case .invalidPriceInput:
            return NSLocalizedString("상품 가격을 입력해주세요.",
                                     comment: "invalid price input")
        case .invalidDiscountInput:
            return NSLocalizedString("상품 할인 가격에 숫자를 입력해주세요",
                                     comment: "invalid discount input")
        case .invalidStockInput:
            return NSLocalizedString("상품 재고에 숫자를 입력해주세요",
                                     comment: "invalid stock input")
        case .invalidDescriptionInput:
            return NSLocalizedString("10자 이상, 1000자 이하의 상품 설명을 입력해주세요.",
                                     comment: "invalid description input")
        case .noImageInput:
            return NSLocalizedString("1개 이상의 상품 사진을 추가해주세요.",
                                     comment: "no image input")
        case .discountOverPrice:
            return NSLocalizedString("할인 가격이 상품 가격을 초과하였습니다.",
                                     comment: "discount over price")
        }
    }
}
