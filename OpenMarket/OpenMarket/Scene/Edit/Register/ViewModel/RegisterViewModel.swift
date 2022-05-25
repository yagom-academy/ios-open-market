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
    
    func setUpDefaultImage() {
        guard let plus = UIImage(named: "plus")?.pngData() else { return }
        images.append(ImageInfo(fileName: "plusButton", data: plus, type: "png"))
        applySnapshot()
    }
    
    func insert(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        images.insert(ImageInfo(fileName: generateUUID(), data: data, type: "jpg"), at: 0)
        applySnapshot()
    }
    
    func removeLastImage() {
        images.removeLast()
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
