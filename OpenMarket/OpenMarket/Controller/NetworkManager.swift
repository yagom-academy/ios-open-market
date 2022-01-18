//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/17.
//

import Foundation

class NetworkManager {
    
    private let urlSessionProvider: URLSessionProvider
    
    var dataFetchHandler: ((Page) -> Void)?
    
    init(handler: ((Page) -> Void)? = nil) {
        urlSessionProvider = URLSessionProvider(session: URLSession.shared)
        self.dataFetchHandler = handler
    }
    
    func fetchPage(pageNumber: String = "1", itemsPerPage: String) {
        urlSessionProvider
            .request(.showProductPage(pageNumber: pageNumber, itemsPerPage: itemsPerPage)) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.dataFetchHandler?(data)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
    }
    
}
