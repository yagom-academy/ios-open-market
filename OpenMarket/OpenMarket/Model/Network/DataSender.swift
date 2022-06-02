//
//  DataSender.swift
//  OpenMarket
//
//  Created by papri, Tiana on 31/05/2022.
//

import UIKit

class DataSender {
    static let shared = DataSender()
    
    private init() { }
    
    func patchProductData(prductIdentifier: Int, productInput: [String: Any], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        HTTPManager().patchData(product: productInput, targetURL: .productPatch(productIdentifier: prductIdentifier)) { data in
            completionHandler(data)
        }
    }
    
    func postProductData(images: [UIImage], productInput: [String: Any], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let imagesData = converImage(from: images)
        HTTPManager().postProductData(images: imagesData, product: productInput, completionHandler: completionHandler)
    }
    
    func converImage(from images: [UIImage]) -> [Data] {
        let imagesData = images.compactMap { image -> Data? in
            guard let imagesData = image.jpegData(compressionQuality: 0.4) else {
                 return nil
            }
            return imagesData
        }
        return imagesData
    }
}
