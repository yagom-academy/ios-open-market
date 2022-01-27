//
//  ProductCreateViewModel.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/27.
//

import UIKit

class ProductCreateViewModel {
    
    private(set) lazy var model = ProductModelManager(modelHandler: self.viewHandler)
    
    let viewHandler: () -> Void
    
    init(viewHandler: @escaping () -> Void) {
        self.viewHandler = viewHandler
    }
    
    func append(image: UIImage) {
        model.append(image: image)
    }
    
    func process(_ form: ProductRegisterForm,
                 completionHandler: ((CreateProductResult) -> Void)? = nil) throws {
        try validate(form: form)
        try model.process(form, completionHandler: completionHandler)
    }
    
    var images: [UIImage] {
        return model.images
    }
    
    var canAddImage: Bool {
        return images.count < MagicNumber.imageMaximumCount
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
        guard form.price != "" else {
            throw ProductCreateError.priceNotEntered
        }
    }
    
}

// MARK: - ProductCreateViewModel Definition
extension ProductCreateViewModel {
    
    private enum MagicNumber {
        
        static let imageMaximumCount = 5
        static let imageMinimumCount = 1
        static let productNameMinimumLength = 3
        static let productDescriptionMaximumLength = 1_000
        
    }
    
    enum ProductCreateError: String, LocalizedError {
        
        case lackOfImage = "최소 한장의 이미지를 첨부해주세요"
        case exceedImage = "최대 첨부 가능한 이미지 수를 초과하였습니다"
        case lackOfLetters = "최소 글자수 이상을 작성해주세요"
        case exceedLetters = "최대 글자수 아래로 줄여주세요"
        case priceNotEntered = "가격 정보가 입력되지 않았습니다"
        
        var errorDescription: String? {
            self.rawValue
        }
        
    }
    
    typealias CreateProductResult = Result<CreateProductResponse, Error>
    
}
