//
//  ProductNetworkManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/20.
//

import Foundation
import UIKit.UIImage

class ProductNetworkManager {
    
    private let urlSessionProvider = URLSessionProvider(session: URLSession.shared)
    
    func fetchPage<T>(pageNumber: String, itemsPerPage: String, completionHandler: ((T) -> Void)? = nil) {
        urlSessionProvider.request(
            .showProductPage(
                pageNumber: pageNumber,
                itemsPerPage: itemsPerPage)
        ) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
            switch result {
            case .success(let data):
                guard let data = data as? T else { return }
                completionHandler?(data)
                
            case .failure(let error):
                print(error)
            }
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
    
    func fetchImages(url: String,
                     completionHandler: ((ProductImageResult) -> Void)? = nil) {
        urlSessionProvider.requestImage(from: url) { result in
            completionHandler?(result)
        }
    }
}

extension ProductNetworkManager {
    
    typealias CreateProductResult = Result<CreateProductResponse, URLSessionProviderError>
    typealias DetailProductResult = Result<ShowProductDetailResponse, URLSessionProviderError>
    typealias ProductImageResult = Result<UIImage, URLSessionProviderError>
    
}
