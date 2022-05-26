//
//  MainViewModel.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/20.
//

import UIKit

final class MainViewModel {
    private enum Constants {
        static let itemsCountPerPage = 20
    }
    
    enum Section: CaseIterable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let productsAPIService = APIProvider<Products>()
    private let productsDetailAPIService = APIProvider<ProductDetail>()
    lazy var imageCacheManager = ImageCacheManager(apiService: productsAPIService)
    
    var datasource: DataSource?
    private(set) var products: Products?
    var items: [Item] = []
    var currentPage = 1
    
    weak var delegate: MainAlertDelegate?
    
    func requestProducts(by page: Int) {
        let endpoint = EndPointStorage.productsList(pageNumber: page, perPages: Constants.itemsCountPerPage)
        
        productsAPIService.retrieveProduct(with: endpoint) { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                self?.items.append(contentsOf: products.items)
                self?.applySnapshot()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.showAlertRequestError(with: error)
                }
            }
        }
    }
    
    func requestProductDetail(by id: Int, completion: @escaping (ProductDetail) -> Void) {
        let endpoint = EndPointStorage.productsDetail(productID: id)
        
        productsDetailAPIService.retrieveProduct(with: endpoint) { [weak self] result in
            switch result {
            case .success(let productDetail):
                completion(productDetail)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.showAlertRequestError(with: error)
                }
            }
        }
    }

    private func applySnapshot() {
        DispatchQueue.main.async {
            var snapshot = Snapshot()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(self.items, toSection: .main)
            self.datasource?.apply(snapshot)
        }
    }
}
