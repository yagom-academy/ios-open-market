//
//  ProductCreateModelManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/19.
//

import Foundation
import UIKit.UIImage

class ProductCreateModelManager: ProductUpdateModelManager {
    
    let networkManager = ProductNetworkManager<CreateProductRequest>()
    
    private var images: [UIImage] = [] {
        didSet { imagesDidChangeHandler?() }
    }
    
    var currentImages: [UIImage] {
        images
    }
    
    private var parsedImages: [Image] {
        images.compactMap { Image(type: .jpeg, data: $0.jpegData(compressionQuality: 1.0)) }
    }
    
    var canAddImage: Bool {
        numberOfImagesRange.contains(images.count)
    }
    
    let numberOfImagesRange = 0..<5
    
    var imagesDidChangeHandler: (() -> Void)?
    
    func append(image: UIImage) {
        images.append(image)
    }
    
    func process(_ form: ProductRegisterForm) -> Bool {
        guard form.name.count >= 3 else { return false }
        guard let currency = Currency(rawValue: form.currency) else { return false }
        
        let params = CreateProductRequestParams(
            name: form.name,
            descriptions: form.description,
            price: form.price.convertToDecimal(),
            currency: currency,
            discountedPrice: form.discountedPrice?.convertToDecimal() ?? 0,
            stock: form.stock?.convertToInt() ?? 0,
            secret: AppConfigure.venderSecret
        )
        
        guard let json = try? JSONEncoder().encode(params) else { return false }
        networkManager.createProductRequest(data: json, images: parsedImages)
        
        return true
    }
    
}
