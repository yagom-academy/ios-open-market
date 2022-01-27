//
//  ProductModelManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/26.
//

import Foundation
import UIKit.UIImage

class ProductModelManager {
    
    private let networkManager = ProductNetworkManager()
    
    private let id: Int
    private(set) var product: Product?
    private(set) var images: [UIImage] = []
    
    let updateHandler: (() -> Void)
    
    init(id: Int, modelHandler: @escaping (() -> Void)) {
        self.id = id
        self.updateHandler = modelHandler
    }
    
    func requestDetailProduct() {
        networkManager.detailProductRequest(id: id) { result in
            switch result {
            case .success(let data):
                self.product = data
                self.requestProductImages()
                self.updateHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestProductImages() {
        product?.images?.forEach({ productImage in
            let url = productImage.url
            networkManager.fetchImages(url: url) { result in
                switch result {
                case.success(let image):
                    self.images.append(image)
                    self.updateHandler()
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
    
}
