//
//  ProductCreateModelManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/19.
//

import Foundation
import UIKit.UIImage

class ProductCreateModelManager {
    
    let networkManager = ProductNetworkManager()
    
    private var images: [UIImage] = [] {
        didSet {
            NotificationCenter.default.post(name: .modelDidChanged, object: nil)
        }
    }
    
    var currentImages: [UIImage] {
        images
    }
    
    private var parsedImages: [Image] {
        images.compactMap { Image(type: .png, data: $0.resizeImage()?.jpegData(compressionQuality: 0.5)) }
    }
    
    var canAddImage: Bool {
        numberOfImagesRange.contains(images.count)
    }
    
    let numberOfImagesRange = 0..<5
    
    func append(image: UIImage) {
        images.append(image)
    }
    
    func process(_ form: ProductRegisterForm, completionHandler: (() -> Void)? = nil,
                 failureHandler: ((Error) -> Void)? = nil) throws {
        try validate(form: form)
        
        guard let currency = Currency(rawValue: form.currency) else { throw ProductCreateError.unknownCurrency }
        
        let params = CreateProductRequestParams(
            name: form.name,
            descriptions: form.description,
            price: form.price.convertToDecimal(),
            currency: currency,
            discountedPrice: form.discountedPrice?.convertToDecimal() ?? 0,
            stock: form.stock?.convertToInt() ?? 0,
            secret: AppConfigure.venderSecret
        )
        
        guard let json = try? JSONEncoder().encode(params) else { throw ProductCreateError.encodingError }
        networkManager.createProductRequest(
            data: json,
            images: parsedImages,
            completionHandler: completionHandler,
            failureHandler: failureHandler
        )
    }
    
    private func validate(form: ProductRegisterForm) throws {
        guard currentImages.count >= 1 else { throw ProductCreateError.lackOfImage }
        guard currentImages.count <= 5 else { throw ProductCreateError.exceedImage }
        guard form.name.count >= 3 else { throw ProductCreateError.lackOfLetters }
        guard form.description.count <= 1000 else { throw ProductCreateError.exceedLetters }
        guard form.price != "" else { throw ProductCreateError.priceNotEntered }
    }
    
    enum ProductCreateError: String, LocalizedError {
        
        case lackOfImage = "최소 한장의 이미지를 첨부해주세요"
        case exceedImage = "최대 첨부 가능한 이미지 수를 초과하였습니다"
        case lackOfLetters = "최소 글자수 이상을 작성해주세요"
        case exceedLetters = "최대 글자수 아래로 줄여주세요"
        case unknownCurrency = "화폐 단위 변환에 실패하였습니다"
        case encodingError = "모델 타입으로 인코딩할 수 없습니다"
        case uploadError = "서버에 업로드할 수 없습니다"
        case priceNotEntered = "가격 정보가 입력되지 않았습니다"
        
        var errorDescription: String? {
            self.rawValue
        }
        
    }
    
}
