//
//  ModifyViewModel.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/25.
//

import UIKit

final class ModifyViewModel: ManagingViewModel {
    func setUpImages(with images: [ProductImage]) {
        images.forEach { image in
            requestImage(url: image.url)
        }
    }
    
    private func requestImage(url: URL) {
        productsAPIServie.requestImage(with: url) { result in
            switch result {
            case .success(let data):
                self.images.append(ImageInfo(fileName: self.generateUUID(), data: data, type: Constants.jpg))
                self.applySnapshot()
            case .failure(let error):
                self.delegate?.showAlertRequestError(with: error)
            }
        }
    }
}
