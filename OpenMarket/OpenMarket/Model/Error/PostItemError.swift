//
//  PostItemError.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/30.
//

import Foundation

enum PostItemError: Error {
    case imageError
    case nameError
    case priceError
    case discountPriceError
    case stockError
}

extension PostItemError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .imageError:
            return "이미지는 최소 1장 이상\n 등록 되어야 합니다"
        case .nameError:
            return "상품명을 3글자 이상 입력해주세요"
        case .priceError:
            return "상품 가격을 정확히 입력해 주세요"
        case .discountPriceError:
            return "할인 가격을 정확히 입력해 주세요"
        case .stockError:
            return "상품 수량을 정확히 입력해 주세요"
        }
    }
}
