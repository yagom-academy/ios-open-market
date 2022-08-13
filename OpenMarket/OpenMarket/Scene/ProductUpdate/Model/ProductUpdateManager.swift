//
//  ProductUpdateManager.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/13.
//

import Foundation

struct ProductUpdateManager {
    static func update(product: RegistrationProduct, productID: String) {
        guard let productData = try? JSONEncoder().encode(product) else { return }
        
        let request = ProductPatchRequest(body: .json(productData), productID: productID)

        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}
