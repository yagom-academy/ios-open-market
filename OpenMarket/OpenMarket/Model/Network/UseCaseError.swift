//
//  UseCaseError.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/30.
//

import Foundation

enum UseCaseError: Error, LocalizedError, ErrorAlertProtocol {
    case decodingError
    case nameError
    case descriptionsError
    case priceError
    case discountedPriceError
    case stockError
    case imageError
    case encodingError
    case imageSizeError
    static var alertTitle = "입력 에러!"

    var alertMessage: String {
        switch self {
        case .decodingError:
            return "파일 형식이 잘못되었습니다."
        case .nameError:
            return "이름은 세글자 이상이 되어야합니다."
        case .descriptionsError:
            return "상품설명은 천글자 이하 입력만 가능합니다."
        case .priceError:
            return "상품 가격은 0원 이상이어야 합니다."
        case .discountedPriceError:
            return "할인 가격은 상품가격 이하이며 0원 이상이어야합니다."
        case .stockError:
            return "재고는 0이상이어야 합니다."
        case .imageError:
            return "이미지가 올바르지 않습니다."
        case .encodingError:
            return "인코딩에 실패하였습니다."
        case .imageSizeError:
            return "이미지 사이즈 오류입니다."
        }
    }
}
