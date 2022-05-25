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
    
    weak var delegate: EditAlertDelegate?
    
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
    
    func requestImage(url: URL) {
        productsAPIServie.requestImage(with: url) { result in
            switch result {
            case .success(let data):
                self.images.append(ImageInfo(fileName: self.generateUUID(), data: data, type: "jpg"))
                self.applySnapshot()
            case .failure(_):
                print("asdf")
            }
        }
    }
    
    func setUpImages(with images: [ProductImage]) {
        images.forEach { image in
            requestImage(url: image.url)
        }
    }
    
    private func generateUUID() -> String {
        return UUID().uuidString + ".jpg"
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
