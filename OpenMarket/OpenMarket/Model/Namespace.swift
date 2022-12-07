//
//  Namespace.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import Foundation

enum HTTPMethod {
    static let get: String = "GET"
    static let post: String = "POST"
    static let patch: String = "PATCH"
    static let delete: String = "DELETE"
}

enum OpenMarketURL {
    static let base: String = "https://openmarket.yagom-academy.kr"
    static let heathChecker: String = "/healthChecker"
    
    case itemPageComponent(pageNo: Int, itemPerPage: Int)
    case productComponent(productID: Int)
    case postProductComponent
    
    var url: String {
        switch self {
        case .itemPageComponent(let pageNo, let itemPerPage):
            return OpenMarketURL.base + "/api/products?page_no=\(pageNo)&items_per_page=\(itemPerPage)"
        case .productComponent(let productID):
            return OpenMarketURL.base + "/api/products/\(productID)"
        case .postProductComponent:
            return OpenMarketURL.base + "/api/products"
        }
    }
}

enum OpenMarketDataText {
    static let stock = "잔여수량: "
    static let soldOut = "품절"
    static let first = 1
    static let last = 100
    static let textViewPlaceHolder = "텍스트를 입력하세요."
}

enum OpenMarketStatus {
    static let noneError = "확인 불가"
}

enum OpenMarketImage {
    static let plus = "plus"
    static let cross = "chevron.right"
}

enum OpenMarketSecretCode {
    static let somPassword = "jbb2dy6r65tkgn3q"
}

enum OpenMarketNaviItem {
    static let addItemTitle = "상품 등록"
    static let editItemTitle = "상품 수정"
    static let cancel = "Cancel"
    static let done = "Done"
}

enum OpenMarketAlert {
    static let confirm = "확인"
    static let productTextLimit = "상품명 글자수 제한"
    static let productTextLimitMessage = "3자 이상 입력이 되어야 합니다."
    static let descTextLimit = "상품 설명 글자수 제한"
    static let descTextLimitMessage = "1자 이상 1000자 이하 입력이 되어야 합니다."
    static let priceEmpty = "가격 미입력"
    static let priceEmptyMessage = "가격이 입력되지 않았습니다. 다시 입력해주세요."
    static let imageLimit = "이미지 등록 불가"
    static let imageLimitMessage = "이미지는 5개까지 등록이 가능합니다."
}

enum OpenMarketPlaceHolder {
    static let productName = "상품명"
    static let price = "상품가격"
    static let priceForSale = "할인금액"
    static let stock = "재고수량"
}
