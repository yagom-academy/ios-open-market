import Foundation

enum ProductRegistrationError: Error {
    case emptyName
    case emptyDiscription
    case emptyPrice
    case emptyCurrency
    case emptyImage
    case maximumCharacterLimit(TextCategory, Int)
    case minimumCharacterLimit(TextCategory, Int)
    case maximumDiscountedPrice(Decimal)
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
        case .maximumCharacterLimit(let category, let count):
            return "\(category)을 \(count)글자 이하로 입력해주세요"
        case .minimumCharacterLimit(let category, let count):
            return "\(category)을 \(count)글자 이상 입력해주세요"
        case .maximumDiscountedPrice(let price):
            return "할인금액을 \(price) 이하로 입력해주세요"
        }
    }
}

extension ProductRegistrationError {
    enum TextCategory: CustomStringConvertible {
        case name
        case description
        
        var description: String {
            switch self {
            case .name:
                return "상품명"
            case .description:
                return "상품설명"
            }
        }
    }
}
