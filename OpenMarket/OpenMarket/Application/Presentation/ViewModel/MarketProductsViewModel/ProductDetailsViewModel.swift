//
//  ProductDetailsViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductDetailsViewModel {
    // MARK: Properties
    
    private var productDetailsEntity: ProductDetailsEntity?
    private var productDetails: ProductDetail?
    
    weak var delegate: ProductDetailsViewDelegate?
    
    // MARK: - Initializer
    init() {}
    
    init(productDetailEntity: ProductDetailsEntity) {
        self.productDetailsEntity = productDetailEntity
    }
    
    var productName: String? {
        guard let productDetailsEntity = productDetailsEntity else {
            return nil
        }
        
        return productDetailsEntity.name
    }
    
    var currency: String? {
        guard let productDetailsEntity = productDetailsEntity else {
            return nil
        }
        
        return productDetailsEntity.currency.rawValue
    }
    
    var originalPriceText: String? {
        guard let productDetailsEntity = productDetailsEntity else {
            return nil
        }
        
        return productDetailsEntity.currency.rawValue + " " + (productDetailsEntity.price.numberFormatter())
    }
    
    var discountedPriceText: String? {
        guard let productDetail = productDetailsEntity else {
            return nil
        }
        
        return productDetail.currency.rawValue + " " + (productDetail.bargainPrice.numberFormatter())
    }
    
    var stockText: String? {
        guard let productDetail = productDetailsEntity else {
            return nil
        }
        
        return isEmptyStock == true ? "품절" : "남은 수량 : \(productDetail.stock)"
    }
    
    var description: String? {
        guard let productDetail = productDetailsEntity else {
            return nil
        }
        
        return productDetail.description
    }
    
    var isDiscountedItem: Bool? {
        guard let productDetail = productDetailsEntity else {
            return nil
        }
        
        return productDetail.price != productDetail.bargainPrice
    }
    
    var isEmptyStock: Bool? {
        guard let productDetail = productDetailsEntity else {
            return nil
        }
        
        return productDetail.stock == 0
    }
    
    var numberOfImages: Int? {
        if let images = productDetails?.images {
            return images.count
        }
        return nil
    }

    func format(productDetail: ProductDetail) {
        self.productDetails = productDetail
        
        guard let productImages = productDetail.productImages else {
            return
        }
        
        let productInfo = ProductDetailsEntity(id: productDetail.id,
                                                         venderID: productDetail.venderID,
                                                         name: productDetail.name,
                                                         description: productDetail.description,
                                                         currency: productDetail.currency,
                                                         price: productDetail.price,
                                                         bargainPrice: productDetail.bargainPrice,
                                                         stock: productDetail.stock,
                                                         images: productImages)
        
        delegate?.productDetailsViewController(ProductDetailViewController.self, didRecieve: productImages)
        delegate?.productDetailsViewController(ProductDetailViewController.self, didRecieve: productInfo)
    }
}
