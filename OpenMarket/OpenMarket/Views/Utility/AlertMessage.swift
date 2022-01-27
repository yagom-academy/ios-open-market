//
//  AlertMessage.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/20.
//

import Foundation

enum AlertMessage {
    static let wrongPassword = "비밀번호가 맞지 않습니다. 다시 시도해주세요."
    static let editProduct = "상품을 편집하시겠습니까?"
    static let dataDeliveredFail = "데이터 전달에 실패하였습니다."
    static let fetchProductError = "상품을 불러오는데 문제가 발생했습니다."
    static let minimumImageCount = "이미지는 최소 1장 등록해야합니다."
    static let maximumImageCount = "이미지는 최대 5개까지 첨부할 수 있어요"
    static let minimumNameCount = "상품명이 세글자 이상이어야 합니다."
    static let requiredPriceCount = "상품가격이 필수적으로 입력되어야 합니다."
    static let minimumDescriptionCount = "상품 내용이 최소 10글자 이상 입력되어야 합니다."
    static let maximumDescriptionCount = "상품 내용의 글자수가\n1000글자를 초과하였습니다."
    static let completeProductRegistration = "상품 등록이 완료되었습니다"
    static let completeProductModification = "상품 수정이 완료되었습니다"
    static let completeProductdelete = "삭제처리가 완료되었습니다."
}
