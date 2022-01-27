//
//  ProductModifyViewModel.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/27.
//

import UIKit

class ProductModifyViewModel {
    
    private let model: ProductModelManager
    private let id: Int
    
    let viewHandler: (() -> Void)
    
    init(id: Int, viewHandler: @escaping () -> Void) {
        self.id = id
        self.viewHandler = viewHandler
        self.model = ProductModelManager(
            id: id, modelHandler: viewHandler
        )
    }
    
    func viewDidLoad() {
        model.requestDetailProduct()
    }
    
    var product: Product? {
        return model.product
    }
    
    var productImages: [UIImage] {
        return model.images
    }
    
    var productNameText: String {
        guard let product = product else { return "" }
        return product.name
    }
    
    var productStockText: String {
        guard let stock = product?.stock else { return "" }
        let productStockValue = String(stock)
        return productStockValue
    }
    
    var productCurrency: String {
        guard let currency = product?.currency else { return "" }
        return "\(currency)"
    }
    
    var productDiscountedText: String {
        guard let discountedPrice = product?.discountedPrice else { return "" }
        let discountedPriceValue = String(discountedPrice)
        return discountedPriceValue
    }
    
    var productPriceText: String {
        guard let price = product?.price else { return "" }
        let productPriceValue = String(price)
        return productPriceValue
    }
    
    var productDescriptionText: String {
        guard let description = product?.descriptions else { return "" }
        return description
    }
    
}

extension ProductModifyViewModel: ProductRegisterViewDataSource {
    
    func loadCurrency() -> String {
        productCurrency
    }
    
    func loadDiscountedPrice() -> String {
        productDiscountedText
    }
    
    func loadStock() -> String {
        productStockText
    }
    
    func loadDescription() -> String {
        productDescriptionText
    }
    
    func loadImage() -> [UIImage] {
        productImages
    }
    
    func loadName() -> String {
        productNameText
    }
    
    func loadPrice() -> String {
        productPriceText
    }
    
}
