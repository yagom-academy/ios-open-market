//
//  RegisterViewModel.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit

final class RegisterViewModel {
    enum Section: CaseIterable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ImageInfo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ImageInfo>
    
    private let productsAPIServie = APIProvider<Products>()
    var images: [ImageInfo] = []
    var datasource: DataSource?
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
    
    func appendImages() {
        guard let data1 = UIImage(systemName: "swift")?.pngData() else { return }
        guard let data2 = UIImage(systemName: "swift")?.pngData() else { return }
        guard let data3 = UIImage(systemName: "swift")?.pngData() else { return }
        
        images.append(ImageInfo(fileName: "test1", data: data1, type: "png"))
        images.append(ImageInfo(fileName: "test2", data: data2, type: "png"))
        images.append(ImageInfo(fileName: "test3", data: data3, type: "png"))
        images.append(ImageInfo(fileName: "test4", data: data3, type: "png"))
        images.append(ImageInfo(fileName: "test5", data: data3, type: "png"))
        
        applySnapshot()
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
