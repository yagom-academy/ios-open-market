//
//  NetworkLayer.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct NetworkLayer {
    private let httpRequest = HTTPRequest()
    
    func itemList(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlRequest = httpRequest.CreateURLRequest(requestAPI: .itemList) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ItemList.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func requestRegistration(bodyData: ItemRegistrationRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlRequest = httpRequest.CreateItemRegistrationURLRequest(requestAPI: .itemRegistration, bodyData: bodyData) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ItemRegistrationResponse.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func requestSpecification(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlRequest = httpRequest.CreateURLRequest(requestAPI: .itemSpecification) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ItemSpecification.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func requestModification(bodyData: ItemModificationRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlRequest = httpRequest.CreateItemModificationURLRequest(requestAPI: .itemModification, bodyData: bodyData) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ItemModificationResponse.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func requestDeletion(bodyData: ItemDeletionRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlRequest = httpRequest.CreateItemDeletionURLRequest(requestAPI: .itemDeletion, bodyData: bodyData) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ItemDeletionResponse.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
