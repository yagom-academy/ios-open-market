//
//  ProductNetworkManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/20.
//

import Foundation
import UIKit.UIImage

class ProductNetworkManager {
    
    static let shared = ProductNetworkManager()
    
    private let urlSessionProvider = URLSessionProvider(session: URLSession.shared)
    private let imageCache = NSCache<NSString, UIImage>()
    
    func fetchPage<T>(pageNumber: String, itemsPerPage: String, completionHandler: ((T) -> Void)? = nil) {
        urlSessionProvider.request(
            .showProductPage(
                pageNumber: pageNumber,
                itemsPerPage: itemsPerPage)
        ) { (result: Result<ShowProductPageResponse, Error>) in
            switch result {
            case .success(let data):
                guard let data = data as? T else { return }
                completionHandler?(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestProductSecret(id: Int, completionHandler: ((SecretProductResult) -> Void)? = nil) {
        urlSessionProvider.request(
            .showProductSecret(
                sellerID: AppConfigure.venderIdentifier, sellerPW: AppConfigure.venderSecret, productID: String(id)
            )) { result in
                switch result {
                case .success(let data):
                    guard let secret = String(data: data, encoding: .utf8) else {
                        completionHandler?(.failure(URLSessionProviderError.decodingError))
                        return
                    }
                    completionHandler?(.success(secret))
                case .failure(let error):
                    completionHandler?(.failure(error))
                }
                
            }
    }
    
    func requestDeleteProduct(id: Int, secret: String, completionHandler: ((DeleteProductResult) -> Void)? = nil) {
        urlSessionProvider.request(
            .deleteProduct(
                sellerID: AppConfigure.venderIdentifier, productID: String(id), productSecret: secret
            )) { (result: DeleteProductResult) in
                completionHandler?(result)
        }
    }
    
    func createProductRequest(data: Data, images: [Image],
                              completionHandler: ((CreateProductResult) -> Void)? = nil) {
        urlSessionProvider.request(
            .createProduct(
                sellerID: AppConfigure.venderIdentifier, params: data,images: images
            )) { (result: CreateProductResult) in
            completionHandler?(result)
        }
        
    }
    
    func detailProductRequest(id: Int, completionHandler: ((DetailProductResult) -> Void)? = nil) {
        urlSessionProvider.request(.showProductDetail(productID: String(id))) { (result: DetailProductResult) in
            completionHandler?(result)
        }
    }
    
    func modifyProductRequest(id: Int, requestForm: UpdateProductRequestModel,
                              completionHandeler: ((UpdateProductResult) -> Void)? = nil) {
        urlSessionProvider.request(
            .updateProduct(
                sellerID: AppConfigure.venderIdentifier, productID: String(id), body: requestForm
            )) { (result: UpdateProductResult) in
            completionHandeler?(result)
        }
    }
    
    func fetchImages(url: String,
                     completionHandler: ((ProductImageResult) -> Void)? = nil) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completionHandler?(.success(cachedImage))
            return
        }
                
        urlSessionProvider.requestImage(from: url) { result in
            switch result {
            case .success(let image):
                self.imageCache.setObject(image, forKey: url as NSString)
                completionHandler?(.success(image))
            case .failure(let error):
                completionHandler?(.failure(error))
            }
        }
    }
    
}

extension ProductNetworkManager {
    
    typealias CreateProductResult = Result<CreateProductResponse, Error>
    typealias DetailProductResult = Result<ShowProductDetailResponse, Error>
    typealias UpdateProductResult = Result<UpdateProductResponse, Error>
    typealias SecretProductResult = Result<String, Error>
    typealias DeleteProductResult = Result<DeleteProductResponse, Error>
    typealias ProductImageResult = Result<UIImage, Error>
    
}
