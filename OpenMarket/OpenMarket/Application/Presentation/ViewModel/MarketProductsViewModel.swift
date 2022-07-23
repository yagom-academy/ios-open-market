//
//  MarketProductsViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
//

import UIKit

final class MarketProductsViewModel {
    private var products: [Product] = []
    
    var isDiscountedItem: Bool = true {
        
    }
    
    init(products: [Product]) {
        self.products = products
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
