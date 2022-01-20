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
    
    func process(_ form: Form) -> Bool {
        guard let name = form.name, name.count >= 3 else { return false }
        guard let price = form.price?.convertToDecimal() else { return false }
        guard let currencyString = form.currency else { return false }
        guard let currency = Currency(rawValue: currencyString) else { return false }
        guard let description = form.description else { return false }
        
        let params = CreateProductRequestParams(
            name: name,
            descriptions: description,
            price: price,
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
