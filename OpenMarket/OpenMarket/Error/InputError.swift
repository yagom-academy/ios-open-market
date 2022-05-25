//
//  InputError.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/25.
//

import Foundation

//guard editView.productNameTextField.text?.count ?? 0 >= 3 else {
//    print("3글자 이상 입력해 주세요")
//    return false
//}
//
//guard let productPrice = Int(editView.productPriceTextField.text ?? "0") else {
//    print("상품가격을 입력하세요.")
//    return false
//}
//
//guard let discountedPrice = Int(editView.productDiscountedTextField.text ?? "0"),
//        productPrice >= discountedPrice else {
//    print("할인금액이 더 클수는 없어")
//    return false
//}
//
//guard viewModel.images.count >= 2 else {
//    print("1개 이상의 사진이 필요합니다")
//    return false
//}

enum InputError: LocalizedError {
    case productNameIsTooShort
    case productPriceIsEmpty
    case discountedPriceHigherThanPrice
    case productImageIsEmpty
    case imageIsFull
    case descriptionIsTooLong

    var errorDescription: String? {
        switch self {
        case .productNameIsTooShort: return "상품명을 3글자 이상 입력해 주세요."
        case .productPriceIsEmpty: return "상품가격을 입력하세요."
        case .discountedPriceHigherThanPrice: return "할인금액이 가격보다 더 클 수 없습니다."
        case .productImageIsEmpty: return "1개 이상의 사진이 필요합니다."
        case .imageIsFull: return "사진은 5장만 등록할 수 있습니다."
        case .descriptionIsTooLong: return "설명은 1000자 이하로 입력 가능합니다."
        }
    }
}
