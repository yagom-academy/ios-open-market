//
//  Message.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/11.
//

import Foundation

enum Message {
    static let unknownError = "알 수 없는 에러가 발생했습니다."
    static let badRequest = "잘못된 요청입니다."
    static let minimumImageCount = "이미지는 최소 1장 등록해야합니다."
    static let maximumImageCount = "이미지는 최대 5개까지 첨부할 수 있어요"
    static let minimumNameCount = "상품명이 세글자 이상이어야 합니다."
    static let minimumPriceCount = "상품가격이 필수적으로 입력되어야 합니다."
    static let minimumDescriptionCount = "상품 내용이 최소 10글자 이상 입력되어야 합니다."
    static let maximumDescriptionCount = "상품 내용의 글자수가\n1000글자를 초과하였습니다."
}
