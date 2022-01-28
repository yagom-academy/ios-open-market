//
//  ProductDetailViewModel.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/27.
//

import UIKit

class ProductDetailViewModel {
    
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
    
    func deleteProduct(completionHandler: ((Result<Product, Error>) -> Void)? = nil) {
        model.requestDeleteProduct(completionHandler: completionHandler)
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
        let productStockValue = stock > 0 ? "재고수량 : \(stock)" : "품절"
        return productStockValue
    }
    
    var productCurrency: String {
        guard let currency = product?.currency else { return "" }
        return "\(currency)"
    }
    
    var productOriginalPriceText: String {
        guard let discountedPrice = product?.price else { return "" }
        let discountedPriceValue = "\(productCurrency) \(discountedPrice)"
        return discountedPriceValue
    }
    
    var productDiscountedPriceText: String {
        guard let price = product?.bargainPrice else { return "" }
        let productPriceValue = "\(productCurrency) \(price)"
        return productPriceValue
    }
    
    var productDescriptionText: String {
        guard let description = product?.descriptions else { return "" }
        return description
    }
    
}

extension ProductDetailViewModel: ImageSliderDataSource {
    
    func numberOfImages(in imageSlider: ImageSlider) -> Int {
        productImages.count
    }
    
    func imageSlider(_ imageSlider: ImageSlider, imageForPageAt page: Int) -> UIImage {
        productImages[page]
    }
    
}
