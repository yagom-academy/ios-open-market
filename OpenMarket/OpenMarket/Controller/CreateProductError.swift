//
//  CreateProductError.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/24.
//

import Foundation

enum CreateProductError: Error {
    case invalidProductName
    case invalidDescription
    case invalidPrice
    case invalidDiscountedPrice
    case invalidImages
    case createFailure
    case userInfoError
}
extension CreateProductError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidProductName:
            return "잘못된 상품명입니다"
        case .invalidDescription:
            return "잘못된 상품설명입니다"
        case .invalidPrice:
            return "가격 입력이 잘못되었습니다"
        case .invalidDiscountedPrice:
            return "할인가격 입력이 잘못되었습니다"
        case .invalidImages:
            return "사진을 등록에 문제가 있어요"
        case .createFailure:
            return "상품 등록에 실패하였습니다"
        case .userInfoError:
            return "유저 정보가 잘못되었습니다"
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .invalidProductName:
            return "상품명은 3자 이상 100자 이내로 작성하세요"
        case .invalidDescription:
            return "상품 설명은 최소 10자 최대 1000자로 작성해 주세요"
        case .invalidPrice, .invalidDiscountedPrice:
            return "혹시 숫자 이외의 값을 입력하셨나요?"
        case .invalidImages:
            return "상품 사진은 최소 1장, 최대 5장까지 등록할 수 있어요"
        case .createFailure, .userInfoError:
            return nil
        }
    }
}
