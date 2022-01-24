//
//  ProductNetworkManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/20.
//

import Foundation

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
                              completionHandler: (() -> Void)? = nil,
                              failureHandler: ((Error) -> Void)? = nil) {
        urlSessionProvider.request(
            .createProduct(
                sellerID: AppConfigure.venderIdentifier,
                params: data,
                images: images)
        ) { (result: Result<CreateProductResponse, URLSessionProviderError>) in
            switch result {
            case .success(_):
                completionHandler?()
            case .failure(let error):
                failureHandler?(error)
            }
        }
        
    }
}
