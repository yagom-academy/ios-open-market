//
//  ModifyViewModel.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/25.
//

import UIKit

final class ModifyViewModel: ManagingViewModel, NotificationPostable {
    func setUpImages(with images: [ProductImage]?) {
        images?.forEach { image in
            guard let url = image.url else { return }
            requestImage(url: url)
        }
    }
    
    private func requestImage(url: URL) {
        productsAPIServie.requestImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let imageInfo = ImageInfo(fileName: self.generateUUID(), data: data, type: Constants.jpg)
                self.applySnapshot(image: imageInfo)
            case .failure(let error):
                self.delegate?.showAlertRequestError(with: error)
            }
        }
    }
    
    func requestPatch(productID: Int?, _ productPatch: ProductRequest, completion: @escaping () -> ()) {
        let endpoint = EndPointStorage.productModify(productID: productID, body: productPatch)
        
        productsAPIServie.updateProduct(with: endpoint) { [weak self] result in
            switch result {
            case .success():
                self?.postNotification()
                completion()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.showAlertRequestError(with: error)
                }
            }
        }
    }
}
