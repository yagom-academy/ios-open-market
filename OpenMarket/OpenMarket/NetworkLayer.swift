//
//  NetworkLayer.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/01/27.
//

import Foundation

struct NetworkLayer {
    private let httpRequest = HTTPRequest()
    
    func requestItemList(page: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let urlRequest = httpRequest.itemList(id: page) else {
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
        guard let urlRequest = httpRequest.itemRegistration(bodyData: bodyData) else {
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
                    let decodedData = try JSONDecoder().decode(ItemSpecificationResponse.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func requestSpecification(number: Int, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let urlRequest = httpRequest.itemSpecification(number: number) else {
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
                    let decodedData = try JSONDecoder().decode(ItemSpecificationResponse.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func requestModification(number: Int, bodyData: ItemModificationRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlRequest = httpRequest.itemModification(number: number, bodyData: bodyData) else {
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
                    let decodedData = try JSONDecoder().decode(ItemSpecificationResponse.self, from: data)
                    completionHandler(data, response, error)
                    print(decodedData)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func requestDeletion(number: Int, bodyData: ItemDeletionRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let urlRequest = httpRequest.itemDeletion(number: number, bodyData: bodyData) else {
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
