//
//  ProductNetworkManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/20.
//

import Foundation

class ProductNetworkManager<T> {
    
    private let urlSessionProvider: URLSessionProvider
    
    var dataFetchHandler: ((T) -> Void)?
    
    init() {
        urlSessionProvider = URLSessionProvider(session: URLSession.shared)
    }
    
    func fetchPage(pageNumber: String = "1", itemsPerPage: String) {
        urlSessionProvider.request(
            .showProductPage(
                pageNumber: pageNumber,
                itemsPerPage: itemsPerPage)
        ) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        guard let data = data as? T else { return }
                        self.dataFetchHandler?(data)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
    }
    
    func createProductRequest(data: Data, images: [Image]) {
        urlSessionProvider.request(
            .createProduct(
                sellerID: AppConfigure.venderIdentifier,
                params: data,
                images: images)
        ) { (result: Result<CreateProductResponse, URLSessionProviderError>) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
