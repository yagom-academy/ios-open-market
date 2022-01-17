//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/17.
//

import Foundation

class NetworkManager {
    
    private let urlSessionProvider: URLSessionProvider
    
    weak var delegate: NetworkManagerDelegate?
    
    init() {
        urlSessionProvider = URLSessionProvider(session: URLSession.shared)
    }
    
    func fetchPage(pageNumber: String = "1", itemsPerPage: String) {
        urlSessionProvider
            .request(.showProductPage(pageNumber: pageNumber, itemsPerPage: itemsPerPage)) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.delegate?.fetchRequest(data: data)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
    }
    
}
