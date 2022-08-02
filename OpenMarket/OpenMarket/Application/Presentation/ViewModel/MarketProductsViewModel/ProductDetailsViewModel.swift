//
//  ProductDetailsViewModel.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductDetailsViewModel {
    // MARK: Properties
    
    private var productDetail: ProductDetail?
    weak var delegate: ProductDetailsViewDelegate?
    
    // MARK: - Initializer
    init() {}
    
    var numberOfImages: Int? {
        if let images = productDetail?.images {
            return images.count
        }
        return nil
    }

    func format(productDetail: ProductDetail) {
        self.productDetails = productDetail
        
        guard let productImages = productDetail.productImages else {
            return
        }
        
        delegate?.didReceiveResponse(ProductDetailViewController.self, by: productImages)
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
