//
//  MarketProductsViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
//

import UIKit

final class MarketProductsViewModel {
    private var products: [Product] = []
    private var product: ProductEntity?
    // MARK: Properties
    
    init(products: [Product]) {
        self.products = products
    }
    
    init(product: ProductEntity) {
        self.product = product
    }
    
    
    func fetchData() -> [ProductEntity] {
        var entityList: [ProductEntity] = []

        for product in products {
            
            guard let thumbnailImage = product.thumbnailImage else {
                break
            }
            
            entityList.append(
                ProductEntity(
                    thumbnailImage: thumbnailImage,
                    name: product.name,
                    currency: product.currency,
                    originalPrice: product.price,
                    discountedPrice: product.bargainPrice,
                    stock: product.stock))
        }
        
        return entityList
    }
}

extension MarketProductsViewModel {
    var thumbnailImage: UIImage? {
        guard let product = product else {
            return nil
        }
        
        return product.thumbnailImage
    }
    
    var name: String? {
        guard let product = product else {
            return nil
        }
        
        return product.name
    }
    
    var currency: String? {
        guard let product = product else {
            return nil
        }
        
        return product.currency
    }
    
    var originalPriceText: String? {
        guard let product = product else {
            return nil
        }
        
        return product.currency + " " + (product.originalPrice.numberFormatter())
    }
    
    var discountedPriceText: String? {
        guard let product = product else {
            return nil
        }
        
        return product.currency + " " + (product.discountedPrice.numberFormatter())
    }
    
    var stockText: String? {
        guard let product = product else {
            return nil
        }
        
        return isEmptyStock == true ? "품절" : "잔여수량 : \(product.stock)"
    }
    
    var isDiscountedItem: Bool? {
        guard let product = product else {
            return nil
        }
        
        return product.originalPrice == product.discountedPrice
    }
    
    var isEmptyStock: Bool? {
        guard let product = product else {
            return nil
        }
        
        return product.stock == 0
    }
    
    // MARK: - Initializer

}
