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
        self.productDetail = productDetail
        
        guard let productImages = productDetail.productImages else {
            return
        }
        
        delegate?.didReceiveResponse(ProductDetailViewController.self, by: productImages)
    }
}
