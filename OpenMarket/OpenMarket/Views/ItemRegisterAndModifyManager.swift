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

class ItemRegisterAndModifyManager {

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

    func fillWithInformation(_ name: String?,
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
    
    func upload() {}
}
