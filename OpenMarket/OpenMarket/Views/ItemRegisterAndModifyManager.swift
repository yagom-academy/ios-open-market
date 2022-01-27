//
//  ItemRegisterAndModifyManager.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/27.
//

import Foundation
import UIKit

enum CellType {
    case image(model: ImageCollectionViewCellModel)
    case addImage
}

enum Mode: Int {
    case register = 0
    case modify = 1
}

class ItemRegisterAndModifyManager {

    private let vendorIdentification = UserDefaultUtility().getVendorIdentification()
    private let vendorSecret = UserDefaultUtility().getVendorPassword() ?? ""

    private(set) var name: String?
    private(set) var description: String?
    private(set) var price: String?
    private(set) var currency: Currency?
    private(set) var discountedPrice: String?
    private(set) var stock: String?
    private(set) var secret: String?

    private var models: [CellType] = [.addImage]
    private(set) var images: [Data] = []

    init() {}

    func getModelsCount() -> Int {
        return models.count
    }

    func getModel(at index: Int) -> CellType {
        return models[index]
    }

    private func appendImageData(_ image: UIImage) {
        self.images.append(image.pngData()!)
    }

    func appendModel(with image: UIImage) {
        let resizedImage = image.resize(newWidth: 100)
        appendImageData(resizedImage)

        let newModel = ImageCollectionViewCellModel(image: resizedImage)
        let locationOfNewImage = models.count - 1
        models.insert(.image(model: newModel), at: locationOfNewImage)
    }

    private func fillWithInformation(_ name: String?,
                             _ description: String?,
                             _ price: String?,
                             _ currency: String,
                             _ discountedPrice: String?,
                             _ stock: String?) {
        self.name = name
        self.description = description
        self.price = price
        self.currency = Currency(rawValue: currency)
        self.discountedPrice = discountedPrice
        self.stock = stock
    }

    func createItem(by mode: Mode,
                    _ name: String?,
                    _ description: String?,
                    _ price: String?,
                    _ currency: String,
                    _ discountedPrice: String?,
                    _ stock: String?) {
        fillWithInformation(name, description, price, currency, discountedPrice, stock)
        switch mode {
        case .register:
            guard let item = createItemToRegister() else {
                return
            }
            registerItem(item)
        case .modify:
            guard let item = createItemToModify() else {
                return
            }
            modifyItem(item)
        }
    }

    private func createItemToRegister() -> ProductRegistrationRequest? {
        guard let name = self.name,
              let descriptions = self.description,
              let priceString = self.price,
              let price = Int(priceString),
              let currency = self.currency,
              let discoutedPriceString = self.discountedPrice,
              let discountedPrice = Int(discoutedPriceString),
              let stockString = self.stock,
              let stock = Int(stockString) else {
            return nil
        }
        return ProductRegistrationRequest(name: name,
                                          descriptions: descriptions,
                                          price: price,
                                          currency: currency,
                                          discountedPrice: discountedPrice,
                                          stock: stock,
                                          secret: vendorSecret
        )
    }

    private func createItemToModify() -> ProductModificationRequest? {
        guard let name = self.name,
              let descriptions = self.description,
              let priceString = self.price,
              let price = Int(priceString),
              let currency = self.currency,
              let discoutedPriceString = self.discountedPrice,
              let discountedPrice = Int(discoutedPriceString),
              let stockString = self.stock,
              let stock = Int(stockString) else {
            return nil
        }
        return ProductModificationRequest(name: name,
                                          descriptions: descriptions,
                                          price: price,
                                          currency: currency,
                                          discountedPrice: discountedPrice,
                                          stock: stock,
                                          secret: vendorSecret
        )
    }

    private func registerItem(_ item: ProductRegistrationRequest) {
        ProductService().registerProduct(
            parameters: item,
            session: HTTPUtility.defaultSession,
            images: images
        ) { result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    print("\(product) 등록 성공")
                }
            case .failure:
                DispatchQueue.main.async {
                    print("상품 등록 실패")
                }
            }
        }
    }

    private func modifyItem(_ item: ProductModificationRequest) {}
}
