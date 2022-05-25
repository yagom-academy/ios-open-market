//
//  ModifyViewModel.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/25.
//

import UIKit

final class ModifyViewModel {
    enum Section: CaseIterable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ImageInfo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ImageInfo>
    
    var datasource: DataSource?
    
    private let productsAPIServie = APIProvider<Products>()
    private(set) var images: [ImageInfo] = []
    
    weak var delegate: AlertDelegate?
    
    func requestPost(_ productsPost: ProductsPost) {
        let endpoint = EndPointStorage.productsPost(productsPost)
        
        productsAPIServie.registerProduct(with: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
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
            snapshot.appendItems(self.images, toSection: .main)
            self.datasource?.apply(snapshot)
        }
    }
}
