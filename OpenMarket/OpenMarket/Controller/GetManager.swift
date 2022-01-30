//
//  GetManager.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import Foundation

class GetManager {
    
    var itemsPerPage: Int = 20
    var lastLoadedPage: Int = 1
    var hasNextPage: Bool = true
    weak var delegate: GetResultRepresentable?

    func nextPage(completion: @escaping () -> Void = {}) {
        if hasNextPage {
            lastLoadedPage += 1
            fetchPage(completion: completion)
        }
    }

    func update(completion: @escaping () -> Void = {}) {
        itemsPerPage = 20
        lastLoadedPage = 1
        delegate?.getManagerDidResetItems()
        fetchPage {
            completion()
        }
    }

    private func fetchPage(completion: @escaping () -> Void = {}) {
        URLSessionProvider(session: URLSession.shared)
            .request(.showProductPage(pageNumber: String(lastLoadedPage), itemsPerPage: String(itemsPerPage))) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
                switch result {
                case .success(let data):
                    self.hasNextPage = data.hasNext
                    self.delegate?.getManager(didAppendItems: data.pages)
                case .failure(let error):
                    print(error)
                }
                completion()
            }
    }
    
}
