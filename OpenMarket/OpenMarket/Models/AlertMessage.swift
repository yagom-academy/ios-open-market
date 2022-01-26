import Foundation

enum AlertMessage: String {
    case noProductImage
    case notEnoughProductTitleLength
    case noProductPrice
    case invalidDiscountedPrice
    case notEnoughDescriptionLength
    case exceedDescriptionLength
    case deleteProduct
    case deleteSuccess
    case deleteFailure
    
    var title: String {
        switch self {
        case .noProductImage:
            return "등록된 이미지가 없습니다"
        case .notEnoughProductTitleLength:
            return "상품명을 더 길게 쓰세요"
        case .noProductPrice:
            return "입력된 상품 가격이 없습니다"
        case .deleteProduct:
            return "해당 상품을 삭제하시겠습니까?"
        case .deleteSuccess:
            return "삭제 성공"
        case .deleteFailure:
            return "삭제 실패"
        case .notEnoughDescriptionLength:
            return "상품 설명을 더 길게 쓰세요"
        case .exceedDescriptionLength:
            return "상품 설명이 너무 길어요"
        case .invalidDiscountedPrice:
            return "할인 가격이 상품 가격을 초과했어요"
        }
    }
    
    var message: String {
        switch self {
        case .noProductImage:
            return "한 개 이상의 이미지를 필수로 등록해주세요"
        case .notEnoughProductTitleLength:
            return "상품명을 세 글자 이상 입력해주세요"
        case .noProductPrice:
            return "한 자리 이상의 상품 가격을 입력해주세요"
        case .deleteProduct:
            return "알맞은 비밀번호를 입력해주세요"
        case .deleteSuccess:
            return "성공적으로 삭제하였습니다"
        case .deleteFailure:
            return "비밀번호를 다시 확인해주세요."
        case .notEnoughDescriptionLength:
            return "상품 설명은 10자 이상으로 작성해주세요"
        case .exceedDescriptionLength:
            return "상품 설명은 1000자 이하로 작성해주세요"
        case .invalidDiscountedPrice:
            return "할인 가격은 상품 가격 이하로 설정해주세요"
        }
    }
}
