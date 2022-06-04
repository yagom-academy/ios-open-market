//
//  DetailViewModel.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/31.
//

import UIKit

final class DetailViewModel: NotificationPostable {
    enum Section: CaseIterable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ImageInfo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ImageInfo>
    
    var datasource: DataSource?
    var snapshot: Snapshot?
    private(set) var productDetail: ProductDetail?
    
    weak var delegate: AlertDelegate?
    
    private let productsAPIService = APIProvider()
    
    func requestProductDetail(by id: Int, completion: @escaping (ProductDetail) -> Void) {
        let endpoint = EndPointStorage.productDetail(productID: id)
        
        productsAPIService.retrieveProduct(with: endpoint) { [weak self] (result: Result<ProductDetail, Error>) in
            switch result {
            case .success(let productDetail):
                self?.productDetail = productDetail
                self?.setUpImages(with: productDetail.imageInfos)
                completion(productDetail)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.showAlertRequestError(with: error)
                }
            }
        }
    }
    
    func setUpImages(with images: [ProductImage]?) {
        images?.forEach { image in
            guard let url = image.url else { return }
            requestImage(url: url)
        }
    }
    
    private func requestImage(url: URL) {
        productsAPIService.requestImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                let imageInfo = [ImageInfo(fileName: UUID().uuidString, data: image, type: "")]
                self.applySnapshot(image: imageInfo)
            case .failure(let error):
                self.delegate?.showAlertRequestError(with: error)
            }
        }
    }
    
    func requestSecret(secret: ProductRequest, completion: @escaping (String) -> Void) {
        let endpoint = EndPointStorage.productSecret(productID: productDetail?.id, body: secret)
        
        productsAPIService.retrieveSecret(with: endpoint) { [weak self] (result: Result<String, Error>) in
            switch result {
            case .success(let secret):
                completion(secret)
            case .failure(let error):
                self?.delegate?.showAlertRequestError(with: error)
            }
        }
    }
    
    func deleteProduct(secret: String, completion: @escaping () -> Void) {
        let endpoint = EndPointStorage.productDelete(productID: productDetail?.id, secret: secret)
        
        productsAPIService.deleteProduct(with: endpoint) { [weak self] result in
            switch result {
            case .success(_):
                self?.postNotification()
                completion()
            case .failure(let error):
                self?.delegate?.showAlertRequestError(with: error)
            }
        }
    }
    
    func makeSnapshot() -> Snapshot? {
        var snapshot = datasource?.snapshot()
        snapshot?.deleteAllItems()
        snapshot?.appendSections(Section.allCases)
        return snapshot
    }
    
    private func applySnapshot(image: [ImageInfo]) {
        DispatchQueue.main.async {
            self.snapshot?.appendItems(image)
            guard let snapshot = self.snapshot else { return }
            self.datasource?.apply(snapshot, animatingDifferences: false)
        }
    }
}
