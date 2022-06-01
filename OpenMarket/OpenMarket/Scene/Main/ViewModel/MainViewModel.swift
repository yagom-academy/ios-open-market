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
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>
    
    private let productsAPIService = APIProvider()
    lazy var imageCacheManager = ImageCacheManager(apiService: productsAPIService)
    
    var datasource: DataSource?
    var snapshot: Snapshot?
    private(set) var productList: ProductList?
    private var currentPage: Int = .zero
    
    weak var delegate: AlertDelegate?
    
    func requestProducts() {
        currentPage += 1
        
        let endpoint = EndPointStorage.productList(pageNumber: currentPage, perPages: Constants.itemsCountPerPage)
        
        productsAPIService.retrieveProduct(with: endpoint) { [weak self] (result: Result<ProductList, Error>) in
            switch result {
            case .success(let productList):
                guard let result = productList.items else { return }
                self?.productList = productList
                self?.applySnapshot(products: result)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.showAlertRequestError(with: error)
                }
            }
        }
    }

    func makeSnapshot() -> Snapshot? {
        var snapshot = datasource?.snapshot()
        snapshot?.deleteAllItems()
        snapshot?.appendSections(Section.allCases)
        return snapshot
    }
    
    private func applySnapshot(products: [ProductDetail]) {
        DispatchQueue.main.async {
            self.snapshot?.appendItems(products)
            guard let snapshot = self.snapshot else { return }
            self.datasource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func resetItemList() {
        currentPage = .zero
        snapshot = makeSnapshot()
        requestProducts()
    }
}
