//
//  GetManager.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import UIKit

class GetManager {
    
    var itemsPerPage: Int = 20
    var lastLoadedPage: Int = 1
    var hasNextPage: Bool = true
    weak var delegate: DataRepresentable?

    func nextPage(completion: @escaping () -> Void = {}) {
        if hasNextPage {
            lastLoadedPage += 1
            fetchPage(completion: completion)
        }
    }

    func update(completion: @escaping () -> Void = {}) {
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
                    self.delegate?.snapshot.appendItems(data.pages)
                case .failure(let error):
                    print(error)
                }
                completion()
            }
    }
    
}

protocol DataRepresentable: AnyObject {
    var snapshot: NSDiffableDataSourceSnapshot<Int, Product> { get set }
}
