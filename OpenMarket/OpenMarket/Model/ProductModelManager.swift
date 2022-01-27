//
//  ProductModelManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/26.
//

import Foundation
import UIKit.UIImage

class ProductModelManager {
    
    private let networkManager = ProductNetworkManager()
    
    private let id: Int?
    private(set) var product: Product?
    private(set) var images: [UIImage] = []
    
    private var compressedImages: [Image] {
        images.compactMap {
            Image(type: .png,
                  data: $0.resizeImage()?.jpegData(compressionQuality: 0.5))
        }
    }
    
    let updateHandler: (() -> Void)
    
    init(id: Int? = nil, modelHandler: @escaping (() -> Void)) {
        self.id = id
        self.updateHandler = modelHandler
    }
    
    func append(image: UIImage) {
        images.append(image)
        updateHandler()
    }
    
    func process(_ form: ProductRegisterForm, completionHandler: ((CreateProductResult) -> Void)? = nil) throws {
        let params = try form.convertedToCreateProductRequestParams()
        
        guard let json = try? JSONEncoder().encode(params) else { throw ProductCreateModelError.encodingError }
        networkManager.createProductRequest(
            data: json, images: compressedImages) { result in
                completionHandler?(result)
                self.updateHandler()
            }
    }
    
    func requestDetailProduct() {
        guard let id = id else { return }
        networkManager.detailProductRequest(id: id) { result in
            switch result {
            case .success(let data):
                self.product = data
                self.requestProductImages()
                self.updateHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestModifyProduct(form: ProductRegisterForm,
                              completionHandler: ((Result<Product, Error>) -> Void)? = nil) {
        guard let id = id else { return }
        let requestForm = UpdateProductRequestModel(
            name: form.name,
            descriptions: form.description,
            thumbnailID: nil,
            price: Double(form.price),
            currency: Currency(rawValue: form.currency),
            discountedPrice: Double(form.discountedPrice ?? ""),
            secret: AppConfigure.venderSecret
        )
        networkManager.modifyProductRequest(id: id, requestForm: requestForm, completionHandeler: completionHandler)
    }
    
    private func requestProductImages() {
        product?.images?.forEach({ productImage in
            let url = productImage.url
            networkManager.fetchImages(url: url) { result in
                switch result {
                case.success(let image):
                    self.images.append(image)
                    self.updateHandler()
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
    
}

extension ProductModelManager {
    
    enum ProductCreateModelError: String, LocalizedError {
        
        case uploadError = "서버에 업로드할 수 없습니다"
        case encodingError = "모델 타입으로 인코딩할 수 없습니다"
        case unknownCurrency = "화폐 단위 변환에 실패하였습니다"
        
        var errorDescription: String? {
            self.rawValue
        }
        
    }
    
    typealias CreateProductResult = Result<CreateProductResponse, Error>
    
}

// MARK: - ProductRegisterForm Utilities
fileprivate extension ProductRegisterForm {
    
    func convertedToCreateProductRequestParams() throws -> CreateProductRequestParams {
        guard let currency = Currency(rawValue: self.currency) else {
            throw ProductModelManager.ProductCreateModelError.unknownCurrency
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
