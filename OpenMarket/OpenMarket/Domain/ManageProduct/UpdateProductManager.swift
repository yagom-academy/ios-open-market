import Foundation
import UIKit

class UpdateProductManager {
    let productService = ProductService()

    func isAppropriateToRegister(form: ManageProductForm) throws ->
    IsAppropriate<RegisterProductRequest, [Inappropriate]> {
        guard let secret = UserDefaultUtility().getVendorPassword() else {
            throw UserError.passwordNotFound
        }

        var inappropriates: [Inappropriate] = []
        if !form.nameIsAppropriate {
            inappropriates.append(.name)
        }
        if !form.priceIsAppropriate {
            inappropriates.append(.price)
        }
        if !form.discountedPriceIsAppropriate {
            inappropriates.append(.discountedPrice)
        }
        if !form.stockIsAppropriate {
            inappropriates.append(.stock)
        }
        if !form.descriptionIsAppropriate {
            inappropriates.append(.description)
        }

        guard inappropriates.count == 0,
              let name = form.name,
              let price = form.price,
              let currnecyString = form.currency,
              let currency = Currency(rawValue: currnecyString),
              let priceDecimal = Decimal(string: price, locale: nil),
              let discountedPrice = form.discountedPrice,
              let discountedPriceDecimal = Decimal(string: discountedPrice, locale: nil),
              let stock = form.stock,
              let stockInt = Int(stock),
              let description = form.descriptions
        else {
            return .failure(inappropriates)
        }

        return .success(
            RegisterProductRequest(
            name: name,
            descriptions: description,
            price: priceDecimal,
            currency: currency,
            discountedPrice: discountedPriceDecimal,
            stock: stockInt,
            secret: secret)
        )
    }

    func comperess(image: UIImage, to limitedKiloBytes: Int) -> Data {
        let limtedBytes = limitedKiloBytes * 1024
        var quality = 1.0
        var compressedImageData = Data()
        while let data = image.jpegData(compressionQuality: quality), quality >= 0 {
            if data.count >= limtedBytes {
                quality -= 0.1
                continue
            } else {
                compressedImageData = data
                break
            }
        }
        return compressedImageData
    }
}

struct ManageProductForm {
    let name: String?
    let price: String?
    let currency: String?
    let discountedPrice: String?
    let stock: String?
    let descriptions: String?

    var nameIsAppropriate: Bool {
        guard let name = name, name.count > 2 else {
            return false
        }
        return true
    }

    var priceIsAppropriate: Bool {
        if price == "" {
            return false
        }
        return true
    }

    var discountedPriceIsAppropriate: Bool {
        guard let discountedPrice = discountedPrice?.decimal,
              let price = price?.decimal,
              price >= discountedPrice else {
            return false
        }
        return true
    }

    var stockIsAppropriate: Bool {
        if stock == "" {
            return false
        }
        return true
    }

    var descriptionIsAppropriate: Bool {
        if descriptions == "" {
            return false
        }
        return true
    }
}

private extension String {
    var decimal: Decimal {
        guard let number = Decimal(string: self, locale: nil) else {
            return Decimal(-1)
        }
        return number
    }
}

enum IsAppropriate<AppropriateForm, Inappropriates> {
    case success(AppropriateForm)
    case failure(Inappropriates)
}

enum Inappropriate: CustomStringConvertible {
    case name
    case description
    case price
    case discountedPrice
    case stock

    var description: String {
        switch self {
        case .name:
            return "상품명"
        case .description:
            return "상세설명"
        case .price:
            return "상품가격"
        case .discountedPrice:
            return "할인금액"
        case .stock:
            return "재고수량"
        }
    }
}
