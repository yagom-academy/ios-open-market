//
//  AlertMessage.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

enum AlertMessage: String {
    case enrollmentSuccess = "상품 등록하였습니다."
    case enrollmentFailure = "상품 등록 실패하였습니다."
    case additionalCharacters = "상품명은 세 글자 이상 입력되어야 합니다."
    case emptyValue = "값이 없습니다."
    case exceedValue = "글자수가 초과되었습니다."
    case exceedImages = "이미지를 추가할 수 없습니다."
}
