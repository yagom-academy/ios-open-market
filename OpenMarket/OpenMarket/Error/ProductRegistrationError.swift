import Foundation

enum ProductRegistrationError: Error {
    case emptyName
    case emptyDiscription
    case emptyPrice
    case emptyCurrency
    case emptyImage
}

extension ProductRegistrationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "상품명을 입력해주세요"
        case .emptyDiscription:
            return "상품설명을 입력해주세요"
        case .emptyPrice:
            return "상품가격을 입력해주세요"
        case .emptyCurrency:
            return "통화가 선택되지 않았습니다"
        case .emptyImage:
            return "이미지를 추가해주세요"
        }
    }
}
