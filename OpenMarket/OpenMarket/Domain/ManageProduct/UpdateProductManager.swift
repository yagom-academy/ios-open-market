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
        if !form.isAppropriateName {
            inappropriates.append(.name)
        }
        if !form.isAppropriatePrice {
            inappropriates.append(.price)
        }
        if !form.isAppropriateDiscountedPrice {
            inappropriates.append(.discountedPrice)
        }
        if !form.isAppropriateStock {
            inappropriates.append(.stock)
        }
        if !form.isAppropriateDescription {
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

    func compress(image: UIImage, to limitedKiloBytes: Int) -> Data {
        let limtedBytes = limitedKiloBytes * 1024
        var quality = 1.0
        var compressedImageData = Data()
        while let data = image.jpegData(compressionQuality: quality), quality >= 0 {
            if data.count >= limtedBytes {
                quality -= 0.1
                continue
            } else {
                compressedImageData = data
                return compressedImageData
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

    var isAppropriateName: Bool {
        guard let name = name, name.count > 2 else {
            return false
        }
        return true
    }

    var isAppropriatePrice: Bool {
        return price != ""
    }

    var isAppropriateDiscountedPrice: Bool {
        guard let discountedPrice = discountedPrice?.decimal,
              let price = price?.decimal,
              price >= discountedPrice else {
            return false
        }
        return true
    }

    var isAppropriateStock: Bool {
        return stock != ""
    }

    var isAppropriateDescription: Bool {
        return descriptions != ""
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

enum Inappropriate: String {
    case name = "상품명"
    case description = "상세설명"
    case price = "상품가격"
    case discountedPrice = "할인금액"
    case stock = "재고수량"
}
