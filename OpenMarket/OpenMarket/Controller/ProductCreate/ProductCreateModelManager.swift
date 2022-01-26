//
//  ProductCreateModelManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/19.
//

import Foundation
import UIKit.UIImage

class ProductCreateModelManager: NSObject {
    
    private let networkManager = ProductNetworkManager()
    
    @objc dynamic private(set) var images: [UIImage] = []
    
    private var parsedImages: [Image] {
        images.compactMap { Image(type: .png, data: $0.resizeImage()?.jpegData(compressionQuality: 0.5)) }
    }
    
    var canAddImage: Bool {
        images.count < MagicNumber.imageMaximumCount
    }
    
    func append(image: UIImage) {
        images.append(image)
    }
    
    func process(_ form: ProductRegisterForm, completionHandler: ((CreateProductResult) -> Void)? = nil) throws {
        try validate(form: form)
        let params = try form.convertedToCreateProductRequestParams()
        
        guard let json = try? JSONEncoder().encode(params) else { throw ProductCreateError.encodingError }
        networkManager.createProductRequest(data: json, images: parsedImages, completionHandler: completionHandler)
    }
    
    private func validate(form: ProductRegisterForm) throws {
        guard images.count >= MagicNumber.imageMinimumCount else {
            throw ProductCreateError.lackOfImage
        }
        guard images.count <= MagicNumber.imageMaximumCount else {
            throw ProductCreateError.exceedImage
        }
        guard form.name.count >= MagicNumber.productNameMinimumLength else {
            throw ProductCreateError.lackOfLetters
        }
        guard form.description.count <= MagicNumber.productDescriptionMaximumLength else {
            throw ProductCreateError.exceedLetters
        }
        guard form.price != "" else { throw ProductCreateError.priceNotEntered }
    }
    
    private enum MagicNumber {
        
        static let imageMaximumCount = 5
        static let imageMinimumCount = 1
        static let productNameMinimumLength = 3
        static let productDescriptionMaximumLength = 1_000
        
    }
    
}

// MARK: - ProductCreateModelManager Definition
extension ProductCreateModelManager {
    
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
    
    typealias CreateProductResult = Result<CreateProductResponse, URLSessionProviderError>
    
}

// MARK: - ProductRegisterForm Utilities
fileprivate extension ProductRegisterForm {
    
    func convertedToCreateProductRequestParams() throws -> CreateProductRequestParams {
        guard let currency = Currency(rawValue: self.currency) else {
            throw ProductCreateModelManager.ProductCreateError.unknownCurrency
        }
        
        let params = CreateProductRequestParams(
            name: self.name,
            descriptions: self.description,
            price: self.price.convertToDecimal(),
            currency: currency,
            discountedPrice: self.discountedPrice?.convertToDecimal() ?? 0,
            stock: self.stock?.convertToInt() ?? 0,
            secret: AppConfigure.venderSecret
        )
        
        return params
    }
    
}
