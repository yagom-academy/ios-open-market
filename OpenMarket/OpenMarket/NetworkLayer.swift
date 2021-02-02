//
//  NetworkLayer.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct NetworkLayer {
    private let httpRequest = OpenMarketHTTPRequest()
    
    func requestItemList(page: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let urlRequest = httpRequest.buildItemList(page) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemList.self, completionHandler: completionHandler)
    }
    
    func requestRegistration(bodyData: ItemRegistrationRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let urlRequest = httpRequest.buildItemRegistration(bodyData) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemSpecificationResponse.self, completionHandler: completionHandler)
    }
    
    func requestSpecification(id: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let urlRequest = httpRequest.buildItemSpecification(id) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemSpecificationResponse.self, completionHandler: completionHandler)
    }
    
    func requestModification(id: Int, bodyData: ItemModificationRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let urlRequest = httpRequest.buildItemModification(id, bodyData) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemSpecificationResponse.self, completionHandler: completionHandler)
    }
    
    func requestDeletion(id: Int, bodyData: ItemDeletionRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let urlRequest = httpRequest.buildItemDeletion(id, bodyData) else {
            return
        }
        request(urlRequest: urlRequest, modelType: ItemDeletionResponse.self, completionHandler: completionHandler)
    }
    
    private func request<T: Decodable>(urlRequest: URLRequest, modelType: T.Type, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(modelType, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
