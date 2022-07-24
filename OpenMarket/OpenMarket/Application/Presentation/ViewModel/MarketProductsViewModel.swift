//
//  MarketProductsViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
//

import UIKit

final class MarketProductsViewModel {
    // MARK: Properties
    
    private var productList: ProductList?
    private var productEntity: ProductEntity?
    
    var thumbnailImage: UIImage? {
        guard let product = productEntity else {
            return nil
        }
        
        return product.thumbnailImage
    }
    
    var name: String? {
        guard let product = productEntity else {
            return nil
        }
        
        return product.name
    }
    
    var currency: String? {
        guard let product = productEntity else {
            return nil
        }
        
        return product.currency
    }
    
    var originalPriceText: String? {
        guard let product = productEntity else {
            return nil
        }
        
        return product.currency + " " + (product.originalPrice.numberFormatter())
    }
    
    var discountedPriceText: String? {
        guard let product = productEntity else {
            return nil
        }
        
        return product.currency + " " + (product.discountedPrice.numberFormatter())
    }
    
    var stockText: String? {
        guard let product = productEntity else {
            return nil
        }
        
        return isEmptyStock == true ? "품절" : "잔여수량 : \(product.stock)"
    }
    
    var isDiscountedItem: Bool? {
        guard let product = productEntity else {
            return nil
        }
        
        return product.originalPrice == product.discountedPrice
    }
    
    var isEmptyStock: Bool? {
        guard let product = productEntity else {
            return nil
        }
        
        return product.stock == 0
    }
    
    // MARK: - Initializer

    init(_ productList: ProductList) {
        self.productList = productList
    }
    
    init(_ productEntity: ProductEntity) {
        self.productEntity = productEntity
    }

    func formatData() -> ProductListEntity? {
        var entityList = ProductListEntity(productEntity: [])
        
        guard let count = productList?.pages else {
            return nil
        }
        
        for product in count {
            guard let thumbnailImage = product.thumbnailImage else {
                break
            }
            
            entityList.productEntity.append(
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
