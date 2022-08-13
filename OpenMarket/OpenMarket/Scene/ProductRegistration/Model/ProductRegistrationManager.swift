//
//  ProductRegistrationManager.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/13.
//

import Foundation

struct ProductRegistrationManager {
    static func register(product: RegistrationProduct, images: [Image]) {
        guard let productData = try? JSONEncoder().encode(product) else { return }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = ProductPostRequest()
        
        request.additionHeaders =
        [
            HTTPHeaders.multipartFormData(boundary: boundary).key: HTTPHeaders.multipartFormData(boundary: boundary).value
        ]
        
        let multiPartFormData =  MultiPartForm(
            jsonParameterName: "params",
            imageParameterName: "images",
            boundary: boundary,
            jsonData: productData,
            images: images)
        
        request.body = .multiPartForm(multiPartFormData)
        
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
